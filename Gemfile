source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'sqlite3-ruby', :require => 'sqlite3'

# requires MODIFIED version of 0.6.3, which I've committed to vendor/cache
# to update to a new version of Fleakr, take into consideration the modifications, described at:
# http://github.com/reagent/fleakr/issues#issue/9
# and decide whether they need to be re-applied.
gem 'fleakr', '0.6.3' 

gem "mongoid", :git => "http://github.com/mongoid/mongoid.git" 
gem 'bson_ext', '1.0.7'

# for importing old data (can be removed eventually)
gem 'fastercsv'

group :development do
  gem 'mongrel'
  gem 'wirble'
end
