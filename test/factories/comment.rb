FactoryGirl.define do

  factory :comment do
    ads_id 1
    body "comentario de prueba"
    created_at Time.zone.now
    user_owner 1
    ip "127.0.0.1"
    updated_at { created_at }
  end
end
