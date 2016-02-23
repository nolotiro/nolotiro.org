# coding: utf-8
# Default admin user (change password after first deploy to a server!)
#

def create_user(role = 0, email = Faker::Internet.email, username = Faker::Name.name)
  pwd = '12345678'
  puts "    #{email}"
  User.create!(
    username: username, 
	  email: email, 
		role: role, 
		password: pwd, 
		password_confirmation: pwd, 
		confirmed_at: Time.now, 
		lang: 'es', 
		woeid: 766273 
	)
end

def create_ad(user)
	timestamp = rand((Time.now - 1.week) .. Time.now)
	ad = Ad.create(
		user: user,
		title: Faker::Hipster.sentence(3).truncate(60),
		created_at: timestamp,
		published_at: timestamp,
		body: Faker::Hipster.paragraphs,
		type: 1,
		status: 1,
		woeid_code: 766273,
		image: Faker::Placeholdit.image,
	  ip: "28.3.2.4"
	)
	ad
end


(1..10).each do |i|
  create_user
end

create_user(1)

puts "Creating Ads"

(1..30).each do |i|
  user = User.offset(rand(User.count)).first
	ad = create_ad(user)
  puts "    #{ad.title}"
end

