FactoryGirl.define do
  factory :user do
    username "Pepito"
    email 'pepito@gmail.com'
    lang 'es'
    password '123456789'
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    username "Admin"
    email 'admin@gmail.com'
    lang 'es'
    password '12435968770'
  end
end
