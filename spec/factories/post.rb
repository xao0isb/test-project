# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    id { Faker::Number.number(digits: 10) }
    creator { create(:user) }
    title { Faker::Music.album }
    content { Faker::Lorem.paragraph }
    region { creator.region }
  end
end
