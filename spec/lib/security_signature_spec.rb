require 'spec_helper'
require 'security_signature'
require 'digest/sha1'

describe SecuritySignature do

  it "should sign correctly" do
    hash = { b: 'x', a: 'y' }
    api_key = SecuritySignature::API_KEY
    expected_signed = Digest::SHA1.hexdigest("a=y&b=x&#{api_key}")

    signed = SecuritySignature.sign(hash)

    signed.should == expected_signed
  end

  context "valid_response?" do

    it "should be true" do
      response = Object.new
      response.stub(:body).and_return("some_body")
      api_key = SecuritySignature::API_KEY
      expected_signature = Digest::SHA1.hexdigest("some_body#{api_key}")
      headers = { 'X-Sponsorpay-Response-Signature' => expected_signature }
      response.stub(:headers).and_return(headers)

      result = SecuritySignature.valid_response?(response)

      result.should be_true
    end

    it "should be false" do
      response = Object.new
      response.stub(:body).and_return("some_body")
      headers = { 'X-Sponsorpay-Response-Signature' => "invalid_signature" }
      response.stub(:headers).and_return(headers)

      result = SecuritySignature.valid_response?(response)

      result.should be_false
    end
  end
end