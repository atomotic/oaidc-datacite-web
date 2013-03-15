require 'httparty'

class Datacite
  include HTTParty
  base_uri 'https://test.datacite.org'
  # PRODUCTION # base_uri 'https://mds.datacite.org'

  def initialize(user, password)
    @auth = {:username => user, :password => password}
  end

  def mint(url, doi)
    options = { :query => {:doi => doi, :url => url}, 
                :basic_auth => @auth, :headers => {'Content-Type' => 'text/plain'} }
    self.class.post('/mds/doi', options)
    # PRODUCTION # self.class.post('/doi', options)
  end


  def metadata(xml)
    options = { :body => xml, :basic_auth => @auth, 
                :headers => {'Content-Type' => 'application/xml;charset=UTF-8'} }
    self.class.post('/mds/metadata', options)
    # PRODUCTION # self.class.post('/metadata', options)
  end

end