class SiteController < ApplicationController

  def index
    expose information
  end

  private

  def information
    {
      name: "Perth Transit API",
      version: 1,
      endpoints: {
        train_stations: train_stations_url(version: 1),
        bus_stops:      bus_stops_url(version: 1),
        train_station:  train_station_url(":identifier", version: 1),
        bus_stop:       bus_stop_url(":identifier", version: 1),
        smart_rider:    smart_rider_url(":identifier", version: 1)
      }
    }
  end

end
