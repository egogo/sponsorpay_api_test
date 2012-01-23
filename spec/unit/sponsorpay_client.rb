require 'spec_helper'
API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
describe SponsorpayClient do
  before :all do
    @client = SponsorpayClient.new(API_KEY)
    base_params = {
                    :appid => 157, :format => "json",
                    :device_id => "2b6f0cc904d137be2e1730235f5664094b831186",
                    :locale => "de", :ip => "109.235.143.113",
                    :timestamp => Time.now.to_i, :offer_types => 112
                  }
    @valid_params = base_params.merge({:uid => 'player1', :pub0 => 'campaign2', :page => 1})
    @valid_params_with_no_offers = @valid_params.merge({:uid => '1'})
    @invalid_params = @valid_params_with_no_offers.merge({:page => 200})
  end
  
  context 'with valid params' do
    it "retruns array of offers" do
      response = mock("Response")
      response.stubs(:body).returns('{"code":"OK","offers":[{"title":"FreeAppDaily","payout":5860,"thumbnail":{"lowres":"mzm.gikuvnrn_square_60.png"}},{"title":"My Country","payout":10610,"thumbnail":{"lowres":"w124.png"}}]}')
      response.stubs(:headers).returns({"X-Sponsorpay-Response-Signature" => Digest::SHA1.hexdigest(response.body+API_KEY)})
      response.stubs(:code).returns(200)
      SponsorpayClient.stubs(:get).returns(response)
      
      offers = @client.get_offers(@valid_params)
      offers.should be_an_instance_of(Array)
      offers.size.should eq(2)
    end
  
    it "retruns empty array when user has no offers" do
      response = mock("Response")
      response.stubs(:body).returns('{"code":"NO_CONTENT", "offers":[]}')
      response.stubs(:headers).returns({"X-Sponsorpay-Response-Signature" => Digest::SHA1.hexdigest(response.body+API_KEY)})
      response.stubs(:code).returns(200)
      SponsorpayClient.stubs(:get).returns(response)
      
      offers = @client.get_offers(@valid_params_with_no_offers)
      offers.should be_an_instance_of(Array)
      offers.size.should eq(0)
    end
    
  end
  
  context 'with invalid params' do
    it "retruns error message when params are not valid" do
      response = mock("Response")
      response.stubs(:body).returns('{"code":"ERROR_INVALID_PAGE", "message":"A non-existing page was requested with the parameter page."}')
      response.stubs(:code).returns(400)
      SponsorpayClient.stubs(:get).returns(response)

      offers = @client.get_offers(@invalid_params)
      offers.should be_an_instance_of(String)
    end
  end
  
end