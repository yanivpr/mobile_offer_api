class OfferRequestsController < ApplicationController
  def new
    @offer_request = OfferRequest.new
  end

  def create
    @offer_request = OfferRequest.new params[:offer_request]

    unless @offer_request.valid?
      flash.now[:alert] = 'Please fix the errors'
      render :new
      return
    end

    offers_response = @offer_request.offers_response

    if offers_response.has_errors
      flash.now[:alert] = offers_response.error_message
      render :new
      return
    end

    @offers = offers_response.offers
  end

end