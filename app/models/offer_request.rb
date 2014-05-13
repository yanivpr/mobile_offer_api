require 'mobile_offer_api'

class OfferRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include MobileOfferApiUrl

  attr_accessor :uid, :pub0, :page

  validates_presence_of :uid, :pub0, :page
  validates_numericality_of :page

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def offers
    MobileOfferApi.new(self).offers
  end

end