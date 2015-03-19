require 'gcoder'

class TrainStation < ActiveRecord::Base
  validates_presence_of :name

  is_sluggable :name
  before_save :geocode_name

  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  def self.station_near(coordinates, distance = 2.5)
    lat, lng = Array(coordinates).join(",").split(",", 2).map { |i| BigDecimal(i) }
    return where(:id => false) if lat.blank? || lng.blank?
    near([lat, lng], distance, :units => :km).order('distance ASC')
  end

  def self.seed!
    destroy_all
    TransperthClient.train_stations.each do |name|
      find_or_create_by_name name.gsub(/ Stn$/, '')
    end
  end

  def self.stop_information
    Thread.current[:TrainStation_stop_information] ||= begin
      parsed_stops = ActiveSupport::JSON.decode File.read Rails.root.join("transit_data", "station-locations.json")
      parsed_stops.each_with_object({}) do |stop, index|
        name, lat, lng = stop
        index[name.downcase] = [lat, lng]
      end
    end
  end

  def self.geocode(name)
    full_name = "#{name} Stn".downcase
    lat, lng = stop_information[full_name]
    return lat, lng
  end

  def self.geocoder
    Thread.current[:TrainStation__geocoder] ||= GCoder.connect(:storage => :heap)
  end

  def times
    TransperthClient.live_times "#{name} Stn"
  end

  def serializable_hash(options = {})
    if options[:compact]
      super(:only => [:name, :lat, :lng]).merge 'compact' => true, 'identifier' => cached_slug
    else
      super(:only => [:name, :lat, :lng], :methods => 'times').merge 'compact' => false, 'identifier' => cached_slug
    end
  end

  def name=(value)
    write_attribute :name, value
    # Reset lat and lng measures.
    self.lat, self.lng = nil, nil
  end

  def geocode_name
    return if lat.present? && lng.present?
    self.lat, self.lng = self.class.geocode name
  end

end
