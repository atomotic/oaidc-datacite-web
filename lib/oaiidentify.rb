module OAI
 class IdentifyResponse
    def repositoryIdentifier
      return doc.find('.//oai:repositoryIdentifier', "oai:http://www.openarchives.org/OAI/2.0/oai-identifier").first.content
    end
   
    def sampleIdentifier
      return doc.find('.//oai:sampleIdentifier', "oai:http://www.openarchives.org/OAI/2.0/oai-identifier").first.content
    end
  end
end