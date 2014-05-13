require 'active_support/concern'
require 'security_signature'
require 'net/http'

module MobileOfferApiUrl

  extend ActiveSupport::Concern

  APP_ID = 157
  FORMAT = 'json'
  DEVICE_ID = "2b6f0cc904d137be2e1730235f5664094b831186"
  LOCALE = 'de'
  IP = '109.235.143.113'
  OFFER_TYPES = 112
  VERSION = 'v1'

  def url
    "#{base_url}?#{params_url}"
  end

  private

  def base_url
    "http://api.sponsorpay.com/feed/#{VERSION}/offers.#{FORMAT}"
  end

  def params_url
    api_params = base_params.merge dynamic_params
    hashkey = SecuritySignature.sign(api_params)
    api_params.merge!({hashkey: hashkey})

    api_params.map { |k, v| "#{k}=#{v}" }.join('&')
  end

  def base_params
    {
      appid: APP_ID,
      ip: IP,
      locale: LOCALE,
      device_id: DEVICE_ID,
      offer_types: OFFER_TYPES,
    }
  end

  def dynamic_params
    {
      pub0: pub0,
      page: page,
      uid: uid,
      timestamp: DateTime.now.to_i
    }
  end

end