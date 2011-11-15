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

end
