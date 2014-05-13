require 'digest/sha1'

class SecuritySignature
  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

  def self.sign(hash)
    parameters = concatenate_sorted_params(hash)
    parameters_with_api_key = concatenate_api_key parameters
    sha1 parameters_with_api_key
  end

  def self.valid_response?(response)
    data = "#{response.body}#{API_KEY}"
    my_hash = sha1 data
    response_hash = response.headers['X-Sponsorpay-Response-Signature']

    my_hash == response_hash
  end

  private

  def self.concatenate_sorted_params(hash)
    hash.sort.map { |k, v| "#{k}=#{v}" }.join('&')
  end

  def self.concatenate_api_key(input)
    "#{input}&#{API_KEY}"
  end

  def self.sha1(input)
    Digest::SHA1.hexdigest(input)
  end

end