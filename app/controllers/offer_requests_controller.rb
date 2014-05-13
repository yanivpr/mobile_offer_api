class OfferRequestsController < ApplicationController
  def new
    @offer_request = OfferRequest.new
  end

  def create
    @offer_request = OfferRequest.new params[:offer_request]

    unless @offer_request.valid?
      render :new, notice: 'Please fix the errors'
      return
    end

    @offers = @offer_request.offers
  end

end