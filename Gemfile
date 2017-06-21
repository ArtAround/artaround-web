source 'http://rubygems.org'

gem 'rails', '5.1.1'

gem 'geocoder', '1.1.8'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'


# gem "mongo", '1.6.1'
gem "mongoid", '~> 6.1.0'
# gem 'mongoid_slug', '0.9.0', :require => 'mongoid/slug'
# gem 'mongoid_slug', :require => 'mongoid/slug'
gem 'mongoid-slug'
# gem 'bson_ext', '1.6.1'
gem 'exifr', :git => 'git://github.com/picuous/exifr.git'

gem 'rails_autolink'

# gem 'mongoid-paperclip', '0.0.7', :require => "mongoid_paperclip"
gem 'mongoid-paperclip', :require => "mongoid_paperclip"

group :development do
  gem 'wirble', '0.1.3'
  gem 'capistrano'
  gem 'rack'
  gem 'unicorn'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "capybara"
  gem 'selenium-webdriver'
  gem 'factory_girl_rails'
  # gem 'debugger'
end

group :test do
  gem 'faker'
end
