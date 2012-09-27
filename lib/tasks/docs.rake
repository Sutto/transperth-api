namespace :doc do

  task :upload_api => [:environment, "doc:api"] do
    require 'fog_site'
    site                   = FogSite.new 'doc.perthtransit.com'
    site.access_key_id     = ENV['PERSONAL_AWS_ACCESS_KEY']
    site.secret_key        = ENV['PERSONAL_AWS_SECRET_KEY']
    site.path              = Rails.root.join('doc', 'generated-api').to_s
    site.destroy_old_files = true
    site.deploy!
  end

end