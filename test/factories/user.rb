FactoryGirl.define do
  factory :user do
    username "Pepito"
    email 'pepito@gmail.com'
    lang 'es'
    password '123456789'
    role 0
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    username "Admin"
    email 'admin@gmail.com'
    lang 'es'
    password '12435968770'
    role 1
  end
end
