$:.push File.expand_path("../lib", __FILE__)

require 'rspec'
require 'sponsorpay_client'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
