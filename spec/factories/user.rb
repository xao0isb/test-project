# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    id { Faker::Number.number(digits: 10) }
    role { "user" }
    login { Faker::Blockchain::Bitcoin.address }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { Faker::Name.middle_name }
    region { create(:region) }
    password { "_" }
  end
end
