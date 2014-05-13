require 'offers_response'

class MobileOfferApi

  def initialize(offer_request)
    @offer_request = offer_request
  end

  def offers
    api_url = @offer_request.url
    response = HTTParty.get(api_url)
    OffersResponse.new(response).offers
  end
end