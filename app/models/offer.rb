class Offer
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

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

end