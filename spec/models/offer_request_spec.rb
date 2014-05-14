require 'spec_helper'

describe OfferRequest do

  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:pub0) }
  it { should validate_numericality_of(:page) }

  subject { OfferRequest.new pub0: 'some_pub0', uid: 'some_uid' }

  context "url" do

    it "should have correct base url" do
      subject.url.should start_with "http://api.sponsorpay.com/feed/v1/offers.json"
    end

    it "should have correct query string" do
      SecuritySignature.stub(:sign).with(anything).and_return("some_hashkey")

      subject.url.should end_with "hashkey=some_hashkey"
      should_have_key_value 'appid', 157
      should_have_key_value 'uid', 'some_uid'
      should_have_key_value 'pub0', 'some_pub0'
      should_have_key_value 'device_id', '2b6f0cc904d137be2e1730235f5664094b831186'
      should_have_key_value 'locale', 'de'
      should_have_key_value 'ip', '109.235.143.113'
      should_have_key_value 'offer_types', '112'
    end

  end

end

def should_have_key_value(key, value)
  subject.url.should =~ /[\?&]#{key}=#{value}&/
end