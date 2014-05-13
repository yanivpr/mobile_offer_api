class OffersController < ApplicationController
  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new params[:offer]

    unless @offer.valid?
      render :new, notice: 'Please fix the errors'
      return
    end

    #api_adapter = MobileOfferAPIAdapter.new(@offer)
    #@offers = api_adapter.offers

    @offers = []
  end

  private


end