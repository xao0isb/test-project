# frozen_string_literal: true

def create_user(region:)
  User.create!(
    role: "user",
    login: Faker::Blockchain::Bitcoin.address,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    middle_name: Faker::Name.middle_name,
    region:,
    password: "_"
  )
end

def create_post(creator:, status: "draft")
  Post.create!(
    creator:,
    title: Faker::Music.album,
    content: Faker::Lorem.paragraph,
    region: creator.region,
    status:,
    reviewed_at: status == "approved" ? Time.now : nil
  )
end

admin_region = Region.create!(name: Faker::Address.state)
# admin
admin = User.create!(
  role: "admin",
  login: "admin",
  first_name: "Admin",
  last_name: "Admin",
  middle_name: "Admin",
  region: admin_region,
  password: "admin"
)
2.times do
  create_post(creator: admin, status: "approved")
end

5.times do |i|
  region = Region.create!(name: Faker::Address.state)
  user = create_user(region:)

  create_post(creator: user)
  create_post(creator: user, status: "review")

  next unless i.even?

  create_user(region:)
  create_post(creator: user, status: "review")
end
