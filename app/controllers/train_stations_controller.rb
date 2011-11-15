class TrainStationsController < ApplicationController
  version 1

  def index
    expose TrainStation.order('name ASC').all, :only => [:id, :name]
  end

end
