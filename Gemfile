source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'
gem 'pg'

gem 'nokogiri'
gem 'api_smith'
gem 'rocket_pants', :path => 'vendor/rocket_pants'
gem 'gcoder'

gem 'awesome_print', :require => nil
gem 'geocoder'

gem "slugged"
gem "thin"

group :test, :development do
  gem 'rr'
  gem 'rspec'
  gem 'rspec-rails'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'simplecov', :platform => 'mri_19'
end

group :production do
  gem 'dalli'
end
