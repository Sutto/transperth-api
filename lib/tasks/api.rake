namespace :api do
  namespace :js do

    desc "Generates the minimal version of the JS api files"
    task :generate do
      require 'uglifier'
      raw_files = Dir[Rails.root.join('js-api', '**/*.js')].reject { |v| v.include? "-min.js" }
      raw_files.each do |file|
        puts "Compressing: #{file}"
        source      = File.read(file)
        compiled    = Uglifier.compile(source)
        destination = file.gsub(".js", "-min.js")
        File.open(destination, "w+") do |f|
          f.write compiled
        end
      end
    end

    desc "Uploads the JS apis to js.perthtransit.com"
    task :upload do
      require 'fog_site'
      site                   = FogSite.new 'js.perthtransit.com'
      site.access_key_id     = ENV['PERSONAL_AWS_ACCESS_KEY']
      site.secret_key        = ENV['PERSONAL_AWS_SECRET_KEY']
      site.path              = Rails.root.join('js-api').to_s
      site.destroy_old_files = false
      site.deploy!
    end

    task default: [:generate, :upload]

  end

  task js: ["api:js:default"]

end