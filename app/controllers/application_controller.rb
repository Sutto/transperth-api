class ApplicationController < RocketPants::Base

  map_error! ActiveRecord::RecordNotFound, RocketPants::NotFound

  # For the api to always revalidate on expiry.
  caching_options[:must_revalidate] = true

  jsonp # Offer JSON across the whole api.

  private

  # Only use timeout-based caching due to the nature of our app.
  def cache_response(resource, single_resource)
    super resource, false
  end

  def rabl(object, template_name = "#{controller_name}/#{action_name}", options = {})
    render_json Rabl.render(object, template_name, :view_path => Rails.root.join('app/views'), :format => :json, :scope => self)
  end
  

end
