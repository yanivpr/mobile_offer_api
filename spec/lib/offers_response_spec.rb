require 'spec_helper'
require 'offers_response'
require 'security_signature'

describe OffersResponse do

  context "process" do

    it "should return error when signature is invalid" do
      SecuritySignature.stub(:valid_response?).and_return(false)
      raw_response = Object.new
      offers_response = OffersResponse.new(raw_response)

      response = offers_response.process

      response.has_errors.should be_true
      response.error_message.should == 'The response is not trustworthy'
      response.offers.should == []
    end

    context "valid signature" do
      before(:each) do
        SecuritySignature.stub(:valid_response?).and_return(true)
      end

      it "should return error when error 500 is received" do
        headers = { 'status' => '500 Internal server error' }
        raw_response = Object.new
        raw_response.stub(:headers).and_return(headers)
        offers_response = OffersResponse.new(raw_response)

        response = offers_response.process

        response.has_errors.should be_true
        response.error_message.should == 'Server error'
        response.offers.should == []
      end

      context "not error 500" do
        before(:each) do
          headers = { 'status' => '200 OK' }
          @raw_response = Object.new
          @raw_response.stub(:headers).and_return(headers)
        end

        it "should return no offers" do
          body = { 'code' => 'NO_CONTENT' }.to_json
          @raw_response.stub(:body).and_return(body)
          offers_response = OffersResponse.new(@raw_response)

          response = offers_response.process

          response.has_errors.should be_false
          response.error_message.should be_blank
          response.offers.should == []
        end

        it "should return error message" do
          body = { 'code' => 'INVALID PAGE', 'message' => 'some message' }.to_json
          @raw_response.stub(:body).and_return(body)
          offers_response = OffersResponse.new(@raw_response)

          response = offers_response.process

          response.has_errors.should be_true
          response.error_message.should == 'some message'
          response.offers.should == []
        end

      end
    end

  end
end