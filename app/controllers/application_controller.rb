class ApplicationController < RocketPants::Base

  map_error! ActiveRecord::RecordNotFound, RocketPants::NotFound

  # For the api to always revalidate on expiry.
  caching_options[:must_revalidate] = true

  jsonp # Offer JSON across the whole api.

  private

  def current_distance
    if params[:distance].present?
      begin
        distance = Float params[:distance].to_s
        # 250m..50km
        [[0.25, distance].max, 50].min
      rescue ArgumentError
        error! :bad_request
      end
    else
      2.5
    end
  end

  # Only use timeout-based caching due to the nature of our app.
  def cache_response(resource, single_resource)
    super resource, false
  end

end
