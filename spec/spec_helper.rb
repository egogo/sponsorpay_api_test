$:.push File.expand_path("../lib", __FILE__)

require 'rspec'
require 'rack/test'
require File.expand_path 'sponsorpay_client'
require File.expand_path 'test_app'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
