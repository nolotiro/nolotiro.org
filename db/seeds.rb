# frozen_string_literal: true

def create_user(role = 0)
  pwd = '12345678'
  loop do
    user = User.new(
      username: Faker::Name.name,
      email: Faker::Internet.email,
      role: role,
      password: pwd,
      password_confirmation: pwd,
      confirmed_at: Time.zone.now,
      woeid: 766_273
    )
    return user if user.save
  end
end

def create_ad(user)
  timestamp = rand((Time.zone.now - 1.week)..Time.zone.now)
  ad = Ad.create(
    user: user,
    title: Faker::Hipster.sentence(3).truncate(60),
    created_at: timestamp,
    published_at: timestamp,
    body: Faker::Hipster.paragraphs.join("\n"),
    type: :give,
    status: :available,
    woeid_code: 766_273,
    image: Faker::Placeholdit.image
  )
  ad
end

10.times { create_user }

create_user(1)

30.times do
  user = User.offset(rand(User.count)).first
  create_ad(user)
end
