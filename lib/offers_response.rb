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
      set_error 'The response is not trustworthy'
      return self
    end

    if error_500?(@raw_response)
      set_error 'Server error'
      return self
    end

    json_response = JSON.parse(@raw_response.body)

    return self if no_content?(json_response)

    if not_ok?(json_response)
      set_error json_response['message']
      return self
    end

    self.offers = json_response['offers']
    #self.offers = offers_manual_test_data
    self
  end

  private

  def set_error(message)
    self.has_errors = true
    self.error_message = message
  end

  def no_content?(json_response)
    json_response['code'] == NO_CONTENT
  end

  def not_ok?(json_response)
    json_response['code'] != OK
  end

  def error_500?(json_response)
    json_response.headers['status'].starts_with?("500")
  end

  def offers_manual_test_data
    [
        {
            'title' => 'offer I',
            'payout' => '3.22$',
            'thumbnail' => {'lowres' => 'http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png'}
        },
        {
            'title' => 'offer II',
            'payout' => '2.41$',
            'thumbnail' => {'lowres' => 'http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png'}
        }
    ]
  end
end