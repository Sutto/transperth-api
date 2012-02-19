require 'spec_helper'

describe BusStopsController do

  use_vcr_cassette :record => :new_episodes

  let(:content_body) { response.decoded_body.response }

  describe 'getting bus stop times' do

    before :each do
      get :show, :version => 1, :id => "10321"
    end

    it 'should have the correct status code' do
      response.should be_successful
    end

    it 'should be json' do
      response.content_type.should == 'application/json'
    end

    it 'should have the station information' do
      content_body.stop_number.should == '10321'
    end

    it 'should include train times' do
      content_body.times.should be_present
      content_body.times.should be_a Array
      content_body.times.each do |time|
        time.time.should be_present
        time.route.should be_present
        time.destination.should be_present
      end
    end

    it 'should be the correct type of response' do
      response.should be_singular_resource
    end


  end

end
