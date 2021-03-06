require 'mobile_offer_api'

class OfferRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include MobileOfferApiUrl

  attr_accessor :uid, :pub0, :page

  validates_presence_of :uid, :pub0
  validates_numericality_of :page, allow_blank: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def offers_response
    MobileOfferApi.new(self).offers_response
  end

end