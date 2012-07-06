class SmartRidersController < ApplicationController

  def show
    smart_rider = TransperthClient.smart_rider(params[:id])
    error! :not_found if smart_rider.blank?
    expose smart_rider
  end

end
