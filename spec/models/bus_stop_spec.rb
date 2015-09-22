require 'spec_helper'

describe BusStop do

  use_vcr_cassette :record => :new_episodes

  let(:base_data) do
    {
      :lat          => (rand() * 360 - 180),
      :lng          => (rand() * 180 - 90),
      :stop_number  => (rand() * 90000 + 10000).to_i,
      :display_name => "Example Test Stop",
      :description  => "Stop of Doom"
    }.tap { |d| d[:gtfs_id] = d[:stop_number] }
  end

  context 'validations' do

    it 'should require a stop number' do
      stop = BusStop.new(base_data.except(:stop_number))
      expect(stop).not_to be_valid
      expect(stop.errors[:stop_number].size).to eq(1)
      stop.stop_number = '12345'
      expect(stop).to be_valid
    end

    it 'should require a gtfs id' do
      stop = BusStop.new(base_data.except(:gtfs_id))
      expect(stop).not_to be_valid
      expect(stop.errors[:gtfs_id].size).to eq(1)
      stop.gtfs_id = 12345
      expect(stop).to be_valid
    end

  end

  it 'should allow you to get a compact version' do
    stop = BusStop.create(base_data.merge(:stop_number => 10000))
    serialized = stop.serializable_hash :compact => true
    expect(serialized.keys).to match_array(%w(stop_number identifier name description lat lng compact))
    expect(serialized['compact']).to be_truthy
    expect(serialized['stop_number']).to be_present
  end

  it 'should allow you to get a full version' do
    stop = BusStop.create(base_data.merge(:stop_number => 10000))
    serialized = stop.serializable_hash
    expect(serialized.keys).to match_array(%w(stop_number identifier name description lat lng times))
    expect(serialized['times']).to be_present
    expect(serialized['stop_number']).to be_present
  end

  it 'should let you fetch times for busses' do
    stop = BusStop.create(base_data.merge(:stop_number => 10000))
    times = stop.times
    expect(times).to be_present
    times.each do |time|
      expect(time).to be_a TransperthClient::BusTime
    end
  end

  it 'should use the stop number for the slug' do
    stop = BusStop.create(base_data.merge(:stop_number => 10000))
    expect(BusStop.find_using_slug!('10000')).to eq(stop)
  end

  it 'should let you import bus stops' do
    stub(BusStop).create.with_any_args.times(any_times)
    BusStop.import!
  end

  it 'should allow you to find stops near a bus stop' do
    list = []
    10.times do |i|
      list << BusStop.create(base_data.merge(:lat => i/1000.0, :lng => i/1000.0))
    end
    expect(list[0, 5]).not_to eq(list.reverse[0, 5])
    expect(BusStop.stop_near('0,0').limit(5).all).to eq(list[0, 5])
    expect(BusStop.stop_near([0,0]).limit(5).all).to eq(list[0, 5])
    expect(BusStop.stop_near([0.011, 0.011]).limit(5).all).to eq(list.reverse[0, 5])
    expect(BusStop.stop_near([0,0], 1000).all).to eq(list)
    expect(BusStop.stop_near([0.011, 0.011], 1000).all).to eq(list.reverse)
    expect(BusStop.stop_near([0, 0], 0.001).all).to eq(list[0, 1])
    expect(BusStop.stop_near([0.011, 0.011], 0.001).all).to eq([])
  end

end
