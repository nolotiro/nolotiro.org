FactoryGirl.define do

  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    username
    email 
    lang 'es'
    password '123456789'
    role 0
    woeid 766273
    confirmed_at          Time.now
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    username
    email 'admin@gmail.com'
    lang 'es'
    password '12435968770'
    role 1
    confirmed_at          Time.now
  end

  factory :non_confirmed_user, class: User do
    username
    email 
    lang 'es'
    password '123456789'
    role 0
    woeid 766273
  end

end
