require 'spec_helper'

describe TransperthClient do

  use_vcr_cassette :record => :new_episodes

  PERTH_LINES = %w(Thornlie Fremantle Armadale Midland)

  describe 'getting details for a smart rider' do

    let(:sm_number) { '036296382' }

    it 'should return the correct type' do
      value = TransperthClient.smart_rider(sm_number)
      value.should be_present
      value.should be_a TransperthClient::SmartRiderStatus
      value.balance.should be_present
      value.autoload.should == true
    end

    # Need numbers with this information to make it useful...

    pending 'should include the concession type'

    pending 'should include when the concession expires'

    it 'should return nil with an invalid number' do
      %w(not_a_number 123123 dfsdf something_else testing123 sr123456789).each do |number|
        TransperthClient.smart_rider(number).should == nil
      end
    end

    it 'should return nil with an unknown number' do
      %w(000000000 111111111 5555555555 123456789).each do |number|
        TransperthClient.smart_rider(number).should == nil
      end
    end

  end

  describe 'getting live train times' do
    
    let(:times) { TransperthClient.live_times("Perth Stn") }

    it 'should return an empty array for unknown stations' do
      TransperthClient.live_times("something else").should == []
      TransperthClient.live_times("Perth").should == []
    end

    it 'should return the correct type of data' do
      times.should be_present
      times.should be_a Array
      times.each do |time|
        time.should be_a TransperthClient::TrainTime
      end
    end

    it 'should include the number of cars' do
      times.each do |time|
        time.cars.should be_present
        time.cars.should be_a Fixnum
      end
    end

    it 'should include the pattern name if present' do
      times.each do |time|
        unless time.pattern.nil?
          time.pattern.should be_a String
          time.pattern.should =~ /^[A-Z]$/
        end
      end
    end

    it 'should include the train time' do
      times.each do |time|
        time.time.should be_present
        time.time.should be_a String
        time.time.should =~ /^\d\d:\d\d$/
      end
    end

    it 'should include data detailing if its on time' do
      times.each do |time|
        [true, false].should include time.on_time
      end
    end

    it 'should include the platform name' do
      times.each do |time|
        time.platform.should be_present
        time.platform.should be_a Fixnum
      end
    end

    it 'should include the current status of the train' do
      times.each do |time|
        time.status.should be_present
        time.status.should be_a String
      end
    end

    it 'should include the train line name' do
      times.each do |time|
        time.line.should be_present
        time.line.should be_a String
        PERTH_LINES.should include time.line
      end
    end

  end

  describe 'getting a list of all train stations' do

    let(:stations) { TransperthClient.train_stations }

    it 'should return an array of strings' do
      stations.should be_present
      stations.should be_all { |r| r.is_a?(String) && r.present? }
    end

    it 'should have correct values' do
      stations.should include 'Kenwick Stn'
      stations.should include 'Perth Stn'
      stations.should include 'Midland Stn'
      stations.should include 'Victoria Park Stn'
      stations.should include 'Fremantle Stn'
    end

  end

  describe 'getting a list of bus times' do

    subject { TransperthClient.bus_times '10321' }

    it 'should return an empty array on an invalid stop' do
      TransperthClient.bus_times(112345).should == []
      TransperthClient.bus_times("dfsdfsdf").should == []
    end

    it 'should return a list of all bus stops' do
      subject.should be_present
      subject.should be_a Array
      subject.each do |s|
        s.should be_a TransperthClient::BusTime
        s.time.should be_present
        s.destination.should be_present
        s.route.should be_present
      end
    end

    it 'should include the time' do
      subject.each do |time|
        time.time.should be_present
        time.time.should be_a String
        time.time.should =~ /^\d\d:\d\d$/
      end
    end

  end

end