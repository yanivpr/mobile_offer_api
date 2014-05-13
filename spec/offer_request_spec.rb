require 'spec_helper'

describe OfferRequest do

  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:pub0) }
  it { should validate_presence_of(:page) }
  it { should validate_numericality_of(:page) }

end