require 'security_signature'

class OffersResponse
  OK = "OK"
  NO_CONTENT = "NO_CONTENT"

  attr_accessor :has_errors, :error_message, :offers

  def initialize(raw_response)
    @raw_response = raw_response
    self.offers = []
  end

  def process
    valid = SecuritySignature.valid_response?(@raw_response)

    unless valid
      self.has_errors = true
      self.error_message = 'The response is not trustworthy'
      return self
    end

    json_response = JSON.parse(@raw_response.body)

    return self if json_response['code'] == NO_CONTENT

    if json_response['code'] != OK
      self.has_errors = true
      self.error_message = json_response['message']
      return self
    end


    self.offers = json_response['offers']
    self
  end
end