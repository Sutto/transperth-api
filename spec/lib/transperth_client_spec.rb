require 'spec_helper'

describe TransperthClient do

  use_vcr_cassette :record => :new_episodes

  PERTH_LINES = %w(Thornlie Fremantle Armadale Midland)

  describe 'getting details for a smart rider' do

    let(:sm_number) { '036296382' }

    it 'should return the correct type' do
      value = TransperthClient.smart_rider(sm_number)
      expect(value).to be_present
      expect(value).to be_a TransperthClient::SmartRiderStatus
      expect(value.balance).to be_present
      expect(value.autoload).to eq(true)
    end

    # Need numbers with this information to make it useful...

    pending 'should include the concession type'

    pending 'should include when the concession expires'

    it 'should return nil with an invalid number' do
      %w(not_a_number 123123 dfsdf something_else testing123 sr123456789).each do |number|
        expect(TransperthClient.smart_rider(number)).to eq(nil)
      end
    end

    it 'should return nil with an unknown number' do
      %w(000000000 111111111 5555555555 123456789).each do |number|
        expect(TransperthClient.smart_rider(number)).to eq(nil)
      end
    end

  end

  describe 'getting live train times' do

    let(:times) { TransperthClient.live_times("Perth Stn") }

    it 'should return an empty array for unknown stations' do
      expect(TransperthClient.live_times("something else")).to eq([])
      expect(TransperthClient.live_times("Perth")).to eq([])
    end

    it 'should return the correct type of data' do
      expect(times).to be_present
      expect(times).to be_a Array
      times.each do |time|
        expect(time).to be_a TransperthClient::TrainTime
      end
    end

    it 'should include the number of cars' do
      times.each do |time|
        expect(time.cars).to be_present
        expect(time.cars).to be_a Fixnum
      end
    end

    it 'should include the pattern name if present' do
      times.each do |time|
        unless time.pattern.nil?
          expect(time.pattern).to be_a String
          expect(time.pattern).to match(/^[A-Z]$/)
        end
      end
    end

    it 'should include the train time' do
      times.each do |time|
        expect(time.time).to be_present
        expect(time.time).to be_a String
        expect(time.time).to match(/^\d\d:\d\d$/)
      end
    end

    it 'should include data detailing if its on time' do
      times.each do |time|
        expect([true, false]).to include time.on_time
      end
    end

    it 'should include the platform name' do
      times.each do |time|
        expect(time.platform).to be_present
        expect(time.platform).to be_a Fixnum
      end
    end

    it 'should include the current status of the train' do
      times.each do |time|
        expect(time.status).to be_present
        expect(time.status).to be_a String
      end
    end

    it 'should include the train line name' do
      times.each do |time|
        expect(time.line).to be_present
        expect(time.line).to be_a String
        expect(PERTH_LINES).to include time.line
      end
    end

  end

  describe 'getting a list of all train stations' do

    let(:stations) { TransperthClient.train_stations }

    it 'should return an array of strings' do
      expect(stations).to be_present
      expect(stations).to be_all { |r| r.is_a?(String) && r.present? }
    end

    it 'should have correct values' do
      expect(stations).to include 'Kenwick Stn'
      expect(stations).to include 'Perth Stn'
      expect(stations).to include 'Midland Stn'
      expect(stations).to include 'Victoria Park Stn'
      expect(stations).to include 'Fremantle Stn'
    end

  end

  describe 'getting a list of bus times' do

    subject { TransperthClient.bus_times '10321' }

    it 'should return an empty array on an invalid stop' do
      expect(TransperthClient.bus_times(112345)).to eq([])
      expect(TransperthClient.bus_times("dfsdfsdf")).to eq([])
    end

    it 'should return a list of all bus stops' do
      expect(subject).to be_present
      expect(subject).to be_a Array
      subject.each do |s|
        expect(s).to be_a TransperthClient::BusTime
        expect(s.time).to be_present
        expect(s.destination).to be_present
        expect(s.route).to be_present
      end
    end

    it 'should include the time' do
      subject.each do |time|
        expect(time.time).to be_present
        expect(time.time).to be_a String
        expect(time.time).to match(/^\d\d:\d\d$/)
      end
    end

  end

end