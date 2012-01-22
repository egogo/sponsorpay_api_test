require 'sinatra'
require 'erb'
require File.expand_path 'lib/sponsorpay_client'

class TestApp
  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
  DEFAULT_PARAMS = {
      :appid => 157,
      :format => "json",
      :device_id => "2b6f0cc904d137be2e1730235f5664094b831186",
      :locale => "de",
      :ip => "109.235.143.113",
      :timestamp => Time.now.to_i,
      :offer_types => 112
  }

  get '/' do
    erb :index
  end


  post '/offers' do
    client = SponsorpayClient.new(API_KEY)
    @offers = client.get_offers(DEFAULT_PARAMS.merge!(params[:client]))
    erb :index
  end
end