require 'spec_helper'

describe BusStopsController do

  use_vcr_cassette :record => :new_episodes

  let(:content_body) { response.decoded_body.response }

  describe 'getting bus stop times' do

    context 'with a valid stop number' do

      before :each do
        BusStop.create({
          :display_name => "Bluebush Av After Gecko Tce",
          :stop_number  => "22959",
          :gtfs_id      => 22959,
          :lat          => -32.1313211111111,
          :lng          => 115.812297777778,
          :description  => nil
        })
        get :show, :version => 1, :id => "22959"
      end

      it 'should have the correct status code' do
        response.should be_successful
      end

      it 'should be json' do
        response.content_type.should == 'application/json'
      end

      it 'should have the station information' do
        content_body.stop_number.should == '22959'
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

    context 'with invalid data' do

      before :each do
        BusStop.where(:stop_number => '12345').should be_blank
        get :show, :version => 1, :id => '12345'
      end

      it 'should return a not found error' do
        response.should be_api_error RocketPants::NotFound
      end

      it 'should have the correct status code' do
        response.status.should == 404
      end

      it 'should be json' do
        response.content_type.should == 'application/json'
      end

    end

  end

end
