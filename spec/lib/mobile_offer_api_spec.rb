require 'spec_helper'
require 'mobile_offer_api'

describe MobileOfferApi do

  it "should return offers response given an offer request" do
    offer_request = Object.new
    offer_request.stub(:url).and_return('some_url')
    http_response = Object.new
    HTTParty.stub(:get).with('some_url').and_return(http_response)
    offers_response = Object.new
    OffersResponse.stub(:new).with(http_response).and_return(offers_response)
    offers_response.should_receive(:process)

    api = MobileOfferApi.new(offer_request)
    api.offers_response
  end
end