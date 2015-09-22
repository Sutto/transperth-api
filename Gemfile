source 'http://rubygems.org'

ruby '2.2.2'

gem 'rails', '~> 3.2.12'
gem 'pg'

gem 'faraday'

gem 'nokogiri'
gem 'api_smith'
gem 'rocket_pants'
gem 'gcoder'
gem 'net-http-persistent'

gem 'awesome_print', require: nil
gem 'geocoder'

gem "slugged"
gem "thin"

gem "emmett"

gem "fog_site"

gem 'test-unit'
gem 'puma'

group :test, :development do
  gem 'rr'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'transpec'
  gem 'uglifier', require: nil
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'simplecov', platform: :mri_19
end

group :production do
  gem 'dalli'
  gem 'rails_12factor'
end
