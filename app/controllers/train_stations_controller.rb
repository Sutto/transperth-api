class TrainStationsController < ApplicationController

  version 1

  caches :index, :show

  def index
    expose TrainStation.order('name ASC').all, :compact => true
  end

  def show
    expose TrainStation.find_using_slug(params[:id])
  end

  private

  def caching_timeout
    params[:action] == 'show' ? 1.minute : 24.hours
  end

  def normalise_object(object, options = {})
    result = super
    if action_name == 'index'
      result.each_with_index { |i, idx| i['url'] = train_station_url(object[idx].to_param) }
    end
    result
  end

end
