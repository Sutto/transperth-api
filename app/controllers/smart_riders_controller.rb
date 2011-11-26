class SmartRidersController < ApplicationController

  def show
    smart_rider = TransperthClient.smart_rider(params[:id])
    raise RocketPants::NotFound if smart_rider.blank?
    expose smart_rider
  end

end
