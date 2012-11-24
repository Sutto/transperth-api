require 'spec_helper'

describe TrainStationsController do

  use_vcr_cassette :record => :new_episodes

  before :each do
    # We want to seed all the train stations...
    TrainStation.create :name => 'Kenwick', :lat => 10, :lng => 10
    TrainStation.create :name => 'Perth',   :lat => 20, :lng => 20
  end

  let(:content_body) { response.decoded_body.response }

  describe 'listing train stations' do

    context 'basic listings' do

      before :each do
        get :index, :version => 1
      end

      it 'should have the correct status code' do
        response.should be_successful
      end

      it 'should include the station url' do
        content_body.each do |item|
          item.url.should be_present
        end
      end

      it 'should be the correct object types' do
        response.should be_collection_resource
      end

      it 'should return compact stations' do
        content_body.should be_all { |r| r.compact }
      end

      it 'should be ordered by name' do
        names = content_body.map { |r| r.name }
        names.should == names.sort
      end

      it 'should not include train times' do
        content_body.should be_all { |r| r.times.nil? }
      end

      it 'should be json' do
        response.content_type.should == 'application/json'
      end

    end

    it 'should let you filter to items near a location' do
      get :index, :version => 1, :near => '10,10'
      content_body.should have(1).station
      content_body.first.name.should == 'Kenwick'
    end

    it 'should allow filtering by distance' do
      mock.proxy(TrainStation).station_near(anything, 4.5) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => 4.5
      response.should be_successful
    end

    it 'should box distances to a minimum' do
      mock.proxy(TrainStation).station_near(anything, 0.25) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => -1
      response.should be_successful
    end

    it 'should box distances to a maximum' do
      mock.proxy(TrainStation).station_near(anything, 50) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => 1000
      response.should be_successful
    end

    it 'should be an error with an invalid distance' do
      get :index, :version => 1, :near => '10,10', :distance => 'abc'
      response.should be_bad_request
      response.should be_api_error RocketPants::BadRequest
    end

  end

  describe 'viewing a specific train station' do

    context 'with a valid train station' do

      before :each do
        get :show, :version => 1, :id => "kenwick"
      end

      it 'should have the correct status code' do
        response.should be_successful
      end

      it 'should be json' do
        response.content_type.should == 'application/json'
      end

      it 'should have the station information' do
        content_body.name.should == 'Kenwick'
        content_body.lat.should be_a String
        content_body.lat.should =~ /^\-?\d+\.\d+$/
        content_body.lng.should be_a String
        content_body.lng.should =~ /^\-?\d+\.\d+$/
        content_body.identifier.should == 'kenwick'
      end

      it 'should not be compact' do
        content_body.compact.should == false
      end

      it 'should include train times' do
        content_body.times.should be_present
        content_body.times.should be_a Array
        content_body.times.each do |time|
          time.time.should be_present
          time.line.should be_present
        end
      end

      it 'should be the correct type of response' do
        response.should be_singular_resource
      end

    end

    it 'should return a not found error without a train station' do
      get :show, :version => 1, :id => 'unknown'
      response.should be_api_error RocketPants::NotFound
    end

  end

end