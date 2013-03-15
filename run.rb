#!/usr/bin/env ruby

require 'bundler/setup'
require 'sinatra'
require 'oai'
require 'uri'
require 'htmlentities'
require 'libxslt'
require 'public_suffix'
require 'redis'

require_relative 'lib/oaiidentify'
require_relative 'lib/datacite'
require_relative 'lib/dcnamespaces'


configure do
  $mdsuser = ""
  $mdspassword = ""
  $redis = Redis.new
end


get "/" do
 erb :index	
end

post "/process" do
    @humanpage = params[:humanpage]
    @oai = params[:oai]

   
    begin
      
      # guess article identifier from decimal in url path
      @id = URI.parse(@humanpage).path.scan(/\d+/).join("/")


      client = OAI::Client.new @oai, :parser=>"libxml"
      @identify = client.identify

      if @identify.sampleIdentifier =~ /article/
        @oaiid = "oai:#{@identify.repositoryIdentifier}:article/#{@id}"
      else 
        @oaiid = "oai:#{@identify.repositoryIdentifier}:#{@id}"
      end

      @metadata = client.get_record :identifier => @oaiid
      xml_doc = XML::Document.string(@metadata.record.metadata.to_s)

      xml_doc.find('.//dc:identifier', namespaces).each { |id|
         if id.attributes[:type] == "dcterms:DOI"
           @ojsdoi = id.content
         end
      }

      if @ojsdoi
        @doi = @ojsdoi
      else
        domain = PublicSuffix.parse URI.parse(@humanpage).host
        @doi = "10.5072/#{domain.sld}/#{@identify.repositoryIdentifier.split(".")[0]}/#{@id}"
      end


      stylesheet_doc = XML::Document.file('public/crosswalk.xsl')
      stylesheet = LibXSLT::XSLT::Stylesheet.new(stylesheet_doc)
      result = stylesheet.apply(xml_doc)      

      @metadatahtml = HTMLEntities.new.encode result.to_s.sub("%%DOI%%", @doi)
      
      $redis.hset @oaiid, "metadata", result
      $redis.hset @oaiid, "doi", @doi


      erb :process, :layout => false
    rescue
      "error occurred. <b>#{$!}</b>"
    end

end

post "/mint" do
  datacite = Datacite.new($mdsuser, $mdspassword)

  xml = $redis.hget(params[:identifier], "metadata").force_encoding("utf-8").sub("%%DOI%%", params[:doi])

  datacite.metadata( xml )
  response = datacite.mint(params[:url], params[:doi])
  
  if response.response.code == "201" 
    "<a href='#{response.header["location"]}'><strong>#{params[:doi].upcase}</strong></a>"
  else
    "<span style='color: red;'>ERROR: #{response}</span>"
  end
end


post "/metadata" do
  xml = $redis.hget params[:identifier], "metadata"
  
  doi = params[:doi]
  if doi
    $redis.hset params[:identifier], "doi", doi
  else
    doi = $redis.hget params[:identifier], "doi"
  end
  
  metadatahtml = HTMLEntities.new.encode xml.force_encoding("utf-8").sub("%%DOI%%", doi)
end	


