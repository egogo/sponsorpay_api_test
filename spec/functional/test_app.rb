require 'spec_helper'
require 'rack/test'
require 'erb'
require File.expand_path 'test_app'

describe TestApp do
  include Rack::Test::Methods
  def app; Sinatra::Application; end
  
  it "should render form" do
    get "/"
    last_response.should be_ok
    last_response.body.should match /<form.*action=\'\/offers\'/
  end
  
  context "with valid parameters" do
    it "should contain div with class offer if user has offers" do
      post '/offers', {:client => {:uid => 'player1', :pub0 => 'campaign2', :page => 1}}
      last_response.should be_ok
      last_response.body.should match /<div class=\'offer\'/
    end
    
    it "should contain div with class no_offers and text 'No offers' if user has no offers" do
      post '/offers', {:client => {:uid => '1', :pub0 => 'campaign2', :page => 1}}
      last_response.should be_ok
      last_response.body.should match /<div class=\'no_offers\'/
      last_response.body.should match /No offers/
    end
  end
  
  context 'with invalid parameters' do
    it "should contain div with class offer if user has offers" do
      post '/offers', {:client => {:uid => 'player1', :pub0 => 'campaign2', :page => 100}}
      last_response.should be_ok
      last_response.body.should match /A non-existing page was requested with the parameter page./
    end
  end
end