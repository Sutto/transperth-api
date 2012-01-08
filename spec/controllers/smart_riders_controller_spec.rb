require 'spec_helper'

describe SmartRidersController do

  use_vcr_cassette :record => :new_episodes  

  let(:content_body) { response.decoded_body.response }

  context 'viewing a smart riders information' do

    it 'should return a not found without a valid smart rider' do
      get :show, :version => 1, :id => '123456789'
      response.should be_api_error RocketPants::NotFound
    end

    context 'with a valid smart rider number' do

      before :each do
        get :show, :version => 1, :id => '036296382'
      end

      it 'should expose the data' do
        content_body.keys.should =~ %w(balance concession_type concession_expires autoload)
        content_body.balance.should be_present
        content_body.balance.should be_a Float
        [true, false].should include content_body.autoload
      end

      it 'should have the correct status code' do
        response.should be_successful
      end

      it 'should be the correct type of response' do
        response.should be_singular_resource
      end

      it 'should return json' do
        response.content_type.should == 'application/json'
      end
    
    end

  end

end
