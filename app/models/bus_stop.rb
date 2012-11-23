require 'csv'

class BusStop < ActiveRecord::Base

  validates_presence_of :stop_number, :gtfs_id

  is_sluggable :stop_number

  geocoded_by :address, latitude: :lat, longitude: :lng

  def self.stop_near(coordinates, distance = 2.5)
    lat, lng = Array(coordinates).join(",").split(",", 2).map { |i| BigDecimal(i) }
    return where(id: false) if lat.blank? || lng.blank?
    near([lat, lng], distance, units: :km).order('distance ASC')
  end

  def self.import!
    delete_all
    CSV.foreach(Rails.root.join('transit_data', 'stops.txt'), :headers => :first_line) do |row|
      create({
        stop_number:  row['stop_code'],
        display_name: row['stop_name'],
        description:  row['stop_desc'].presence,
        lat:          row['stop_lat'],
        lng:          row['stop_lon'],
        gtfs_id:      row['stop_id']
      })
    end
  end

  def serializable_hash(options = {})
    result = super only: %w(stop_number description lat lng)
    result['name']       = display_name
    result['identifier'] = stop_number
    if options[:compact]
      result['compact']  = true
    else
      result['times'] = times
    end
    result
  end

  def times
    @times ||= TransperthClient.bus_times(stop_number)
  end

end
