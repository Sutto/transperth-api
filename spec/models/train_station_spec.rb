require 'spec_helper'

describe TrainStation do

  use_vcr_cassette :record => :new_episodes

  context 'validations' do

    it 'should require a name' do
      station = TrainStation.new
      station.name.should be_blank
      station.should_not be_valid
      station.should have_at_least(1).errors_on(:name)
      station.name = 'New Test Station Name'
      station.should be_valid
    end

  end

  it 'should let you get a compact version' do
    station = TrainStation.create :name => "Kenwick"
    hash = station.serializable_hash :compact => true
    hash.keys.should =~ %w(name lat lng cached_slug compact)
    hash['cached_slug'].should == 'kenwick'
    hash['name'].should == 'Kenwick'
    hash['lat'].should be_a BigDecimal
    hash['lng'].should be_a BigDecimal
    hash['compact'].should == true
  end

  it 'should let you get a full version' do
    station = TrainStation.create :name => "Kenwick"
    hash = station.serializable_hash
    hash.keys.should =~ %w(name lat lng cached_slug times compact)
    hash['compact'].should == false
  end

  it 'should let you fetch the live train times' do
    station = TrainStation.new :name => 'Kenwick'
    times = station.times
    times.should be_present
    times.should be_a Array
    times.each do |time|
      time.should be_a TransperthClient::TrainTime
    end
  end

  it 'should use the name for a slug' do
    station = TrainStation.create :name => 'Mandurah'
    station.cached_slug.should == 'mandurah'
    station.name = 'Perth'
    station.save
    station.cached_slug.should == 'perth'
  end

  it 'should geocode on creation' do
    station = TrainStation.create :name => 'Claisebrook'
    lat, lng = station.lat, station.lng
    lat.should be_present
    lng.should be_present
  end

  it 'should geocode on name change' do
    station = TrainStation.create :name => 'Claisebrook'
    old_details = [station.lat, station.lng]
    station.update_attributes :name => 'Victoria Park'
    station.lat.should be_present
    station.lng.should be_present
    [station.lat, station.lng].should_not == old_details
  end

end