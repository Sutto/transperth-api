require 'spec_helper'

describe TrainStation do

  use_vcr_cassette :record => :new_episodes

  context 'validations' do

    it 'should require a name' do
      station = TrainStation.new
      expect(station.name).to be_blank
      expect(station).not_to be_valid
      expect(station.errors[:stop_number].size).to be >= 1
      station.name = 'New Test Station Name'
      expect(station).to be_valid
    end

  end

  it 'should let you get a compact version' do
    station = TrainStation.create :name => "Kenwick"
    hash = station.serializable_hash :compact => true
    expect(hash.keys).to match_array(%w(name lat lng identifier compact))
    expect(hash['identifier']).to eq('kenwick')
    expect(hash['name']).to eq('Kenwick')
    expect(hash['lat']).to be_a BigDecimal
    expect(hash['lng']).to be_a BigDecimal
    expect(hash['compact']).to eq(true)
  end

  it 'should let you get a full version' do
    station = TrainStation.create :name => "Kenwick"
    hash = station.serializable_hash
    expect(hash.keys).to match_array(%w(name lat lng identifier times compact))
    expect(hash['compact']).to eq(false)
  end

  it 'should let you fetch the live train times' do
    station = TrainStation.new :name => 'Kenwick'
    times = station.times
    expect(times).to be_present
    expect(times).to be_a Array
    times.each do |time|
      expect(time).to be_a TransperthClient::TrainTime
    end
  end

  it 'should use the name for a slug' do
    station = TrainStation.create :name => 'Mandurah'
    expect(station.cached_slug).to eq('mandurah')
    station.name = 'Perth'
    station.save
    expect(station.cached_slug).to eq('perth')
  end

  it 'should geocode on creation' do
    station = TrainStation.create :name => 'Claisebrook'
    lat, lng = station.lat, station.lng
    expect(lat).to be_present
    expect(lng).to be_present
  end

  it 'should geocode on name change' do
    station = TrainStation.create :name => 'Claisebrook'
    old_details = [station.lat, station.lng]
    station.update_attributes :name => 'Victoria Park'
    expect(station.lat).to be_present
    expect(station.lng).to be_present
    expect([station.lat, station.lng]).not_to eq(old_details)
  end

  it 'should allow you to find stops near a train station' do
    list = []
    10.times do |i|
      list << TrainStation.create(:name => "test stop #{i}", :lat => i/1000.0, :lng => i/1000.0)
    end
    expect(list[0, 5]).not_to eq(list.reverse[0, 5])
    expect(TrainStation.station_near('0,0').limit(5).all).to eq(list[0, 5])
    expect(TrainStation.station_near([0,0]).limit(5).all).to eq(list[0, 5])
    expect(TrainStation.station_near([0.011, 0.011]).limit(5).all).to eq(list.reverse[0, 5])
    expect(TrainStation.station_near([0,0], 1000).all).to eq(list)
    expect(TrainStation.station_near([0.011, 0.011]).all).to eq(list.reverse)
    expect(TrainStation.station_near([0,0], 0.001).all).to eq(list[0, 1])
    expect(TrainStation.station_near([0.011, 0.011], 0.001).all).to eq([])
  end

end