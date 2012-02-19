class BusStopsController < ApplicationController

  version 1
  caches  :show

  def show
    times = TransperthClient.bus_times(params[:id])
    expose :stop_number => params[:id], :times => times
  end

  private

  def caching_timeout
    3.minutes
  end

end
