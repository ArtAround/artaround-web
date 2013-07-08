source 'http://rubygems.org'

gem 'rails', '3.2.11'

gem 'geocoder', '1.1.8'

gem "mongo", '1.6.1'
gem "mongoid", '2.4.7'
gem 'mongoid_slug', '0.9.0', :require => 'mongoid/slug'
gem 'bson_ext', '1.6.1'
gem 'exifr', :git => 'git://github.com/picuous/exifr.git'

gem 'rails_autolink'

gem 'mongoid-paperclip', '0.0.7', :require => "mongoid_paperclip"

group :development do
  gem 'wirble', '0.1.3'
  gem 'capistrano', '2.5.21' # update to 2.8.0
  gem 'rack', '1.4.1'
  gem 'rake', '0.9.2.2'
  gem 'unicorn', '4.2.1'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "capybara"
  gem 'selenium-webdriver'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
end
