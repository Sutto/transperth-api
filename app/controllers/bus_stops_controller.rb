class BusStopsController < ApplicationController

  version 1
  caches  :show, :index

  def index
    scope = BusStop.limit(5)
    scope = scope.stop_near(params[:near]) if params[:near]
    expose scope.all, :compact => true
  end

  def show
    bus_stop = BusStop.find_using_slug!(params[:id])
    expose bus_stop
  end

  private

  def caching_timeout
    3.minutes
  end

end
