require 'spec_helper'

describe SmartRidersController do

  use_vcr_cassette :record => :new_episodes  

  let(:content_body) { response.decoded_body.response }

  context 'viewing a smart riders information' do

    it 'should return a not found without a valid smart rider' do
      get :show, :version => 1, :id => '123456789'
      expect(response).to be_api_error RocketPants::NotFound
    end

    context 'with a valid smart rider number' do

      before :each do
        get :show, :version => 1, :id => '036296382'
      end

      it 'should expose the data' do
        expect(content_body.keys).to match_array(%w(balance concession_type concession_expires autoload))
        expect(content_body.balance).to be_present
        expect(content_body.balance).to be_a Float
        expect([true, false]).to include content_body.autoload
      end

      it 'should have the correct status code' do
        expect(response).to be_successful
      end

      it 'should be the correct type of response' do
        expect(response).to be_singular_resource
      end

      it 'should return json' do
        expect(response.content_type).to eq('application/json')
      end
    
    end

  end

end
