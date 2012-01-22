require 'digest/sha1'
require 'httparty'
require 'json'

class SponsorpayClient
  include HTTParty
  base_uri 'http://api.sponsorpay.com/feed/v1'
  
  def initialize(api_key)
    @api_key = api_key
  end
  
  def get_offers(options = {})
    response = self.class.get('/offers.json', :query => options.merge({'hashkey' => generate_hashkey(options)}))
    parsed_response_body = JSON.parse(response.body)
    response_valid?(response) ? parsed_response_body['offers'] : parsed_response_body['message']
  end
  
  protected
  
  def response_valid?(response)
    response.code == 200 && response.headers['X-Sponsorpay-Response-Signature'] == Digest::SHA1.hexdigest(response.body+@api_key)
  end
  
  def params_to_string(params)
    (params.map {|k,v| "#{k}=#{v}"}.sort + [@api_key]).join('&')
  end
  
  def generate_hashkey(params)
    Digest::SHA1.hexdigest(params_to_string(params))
  end
  
end