require 'gcoder'

class TrainStation < ActiveRecord::Base
  validates_presence_of :name

  is_sluggable :name

  def self.seed!
    destroy_all
    TransperthClient.train_stations.each do |name|
      suburb = name.gsub(/ Stn$/, '')
      full_name = "#{name} Train Station, Perth, Western Australia"
      lat, lng = nil, nil
      if location = geocoder["#{name} Train Station, Perth, Western Australia"]
        current = location.first.geometry.location
        lat, lng = current.lat, current.lng
      end
      create :name => suburb,
             :lat  => lat,
             :lng  => lng
    end
  end

  def self.geocoder
    @geocoder ||= GCoder.connect(:storage => :heap)
  end

  def times
    TransperthClient.live_times "#{name} Stn"
  end

  def serializable_hash(options = {})
    if options[:compact]
      super :only => [:name, :lat, :lng, :cached_slug]
    else
      super :only => [:name, :lat, :lng, :cached_slug], :methods => :times
    end
  end

end
