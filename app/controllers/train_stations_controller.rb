class TrainStationsController < ApplicationController

  version 1

  def index
    expose TrainStation.order('name ASC').all, :only => [:id, :name]
  end

  def show
    station = TrainStation.find(params[:id])
    times   = TransperthClient.live_times(station.name)
    expose times
  end

  private

  def normalise_object(object, options = {})
    result = super
    if action_name == 'index'
      result.each { |i| i['url'] = train_station_url(i['id']) }
    end
    result
  end

end
