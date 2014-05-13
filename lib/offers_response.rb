require 'security_signature'

class OffersResponse
  def initialize(raw_response)
    @raw_response = raw_response
  end

  def offers
    valid = SecuritySignature.valid_response?(@raw_response)

    json_response = JSON.parse(@raw_response.body)

    return [] if json_response['count'] == 0

    json_response['offers']
  end
end