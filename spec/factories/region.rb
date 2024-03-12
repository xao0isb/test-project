# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    id { Faker::Number.number(digits: 10) }
    name { Faker::Address.state }
  end
end
