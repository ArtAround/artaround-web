require 'faker'

FactoryGirl.define do
  factory :art do |f|
    f.title Faker::Company.catch_phrase
    f.category "Mural"
    f.artist Faker::Name.name
    f.year (1900+Random.rand(114)).to_s
    f.location [Faker::Address.latitude, Faker::Address.longitude]
    f.description Faker::Lorem.paragraph
    f.location_description Faker::Lorem.sentence
    f.approved true
    f.featured false
  end
end
