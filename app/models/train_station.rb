require 'gcoder'

class TrainStation < ActiveRecord::Base
  validates_presence_of :name

  is_sluggable :name
  before_save :geocode_name

  def self.seed!
    destroy_all
    TransperthClient.train_stations.each do |name|
      create :name => name.gsub(/ Stn$/, '')
    end
  end

  def self.geocode(name)
    full_name = "#{name} Train Station, Perth, Western Australia"
    location = geocoder["#{name} Train Station, Perth, Western Australia"]
    return unless location
    current = location.first.geometry.location
    return current.lat, current.lng
  end

  def self.geocoder
    @geocoder ||= GCoder.connect(:storage => :heap)
  end

  def times
    TransperthClient.live_times "#{name} Stn"
  end

  def serializable_hash(options = {})
    if options[:compact]
      super(:only => [:name, :lat, :lng, :cached_slug]).merge 'compact' => true
    else
      super(:only => [:name, :lat, :lng, :cached_slug], :methods => 'times').merge 'compact' => false
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
