require 'faker'

FactoryGirl.define do
  factory :photo do |f|
    f.attribution_text Faker::Name.name
    f.attribution_url Faker::Internet.url
    f.primary false
    f.image File.new(Rails.root + 'spec/assets/photo.jpg')
  end
end
