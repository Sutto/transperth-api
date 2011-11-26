class ApplicationController < RocketPants::Base

  private

  # Only use timeout-based caching due to the nature of our app.
  def cache_response(resource, single_resource)
    super resource, false
  end

end
