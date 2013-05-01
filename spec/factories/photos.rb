require 'faker'

FactoryGirl.define do
  factory :photo do
    attribution_text { Faker::Name.name }
    attribution_url { Faker::Internet.url }
    primary false
    image File.new(Rails.root + 'spec/assets/photo.jpg')
    art
  end
end
