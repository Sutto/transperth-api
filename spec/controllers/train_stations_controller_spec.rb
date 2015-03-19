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
        expect(response).to be_successful
      end

      it 'should include the station url' do
        content_body.each do |item|
          expect(item.url).to be_present
        end
      end

      it 'should be the correct object types' do
        expect(response).to be_collection_resource
      end

      it 'should return compact stations' do
        expect(content_body).to be_all { |r| r.compact }
      end

      it 'should be ordered by name' do
        names = content_body.map { |r| r.name }
        expect(names).to eq(names.sort)
      end

      it 'should not include train times' do
        expect(content_body).to be_all { |r| r.times.nil? }
      end

      it 'should be json' do
        expect(response.content_type).to eq('application/json')
      end

    end

    it 'should let you filter to items near a location' do
      get :index, :version => 1, :near => '10,10'
      expect(content_body.size).to eq(1)
      expect(content_body.first.name).to eq('Kenwick')
    end

    it 'should allow filtering by distance' do
      double.proxy(TrainStation).station_near(anything, 4.5) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => 4.5
      expect(response).to be_successful
    end

    it 'should box distances to a minimum' do
      double.proxy(TrainStation).station_near(anything, 0.25) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => -1
      expect(response).to be_successful
    end

    it 'should box distances to a maximum' do
      double.proxy(TrainStation).station_near(anything, 50) { |r|  r }
      get :index, :version => 1, :near => '10,10', :distance => 1000
      expect(response).to be_successful
    end

    it 'should be an error with an invalid distance' do
      get :index, :version => 1, :near => '10,10', :distance => 'abc'
      expect(response).to be_bad_request
      expect(response).to be_api_error RocketPants::BadRequest
    end

  end

  describe 'viewing a specific train station' do

    context 'with a valid train station' do

      before :each do
        get :show, :version => 1, :id => "kenwick"
      end

      it 'should have the correct status code' do
        expect(response).to be_successful
      end

      it 'should be json' do
        expect(response.content_type).to eq('application/json')
      end

      it 'should have the station information' do
        expect(content_body.name).to eq('Kenwick')
        expect(content_body.lat).to be_a String
        expect(content_body.lat).to match(/^\-?\d+\.\d+$/)
        expect(content_body.lng).to be_a String
        expect(content_body.lng).to match(/^\-?\d+\.\d+$/)
        expect(content_body.identifier).to eq('kenwick')
      end

      it 'should not be compact' do
        expect(content_body.compact).to eq(false)
      end

      it 'should include train times' do
        expect(content_body.times).to be_present
        expect(content_body.times).to be_a Array
        content_body.times.each do |time|
          expect(time.time).to be_present
          expect(time.line).to be_present
        end
      end

      it 'should be the correct type of response' do
        expect(response).to be_singular_resource
      end

    end

    it 'should return a not found error without a train station' do
      get :show, :version => 1, :id => 'unknown'
      expect(response).to be_api_error RocketPants::NotFound
    end

  end

end