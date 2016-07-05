# frozen_string_literal: true
FactoryGirl.define do

  factory :ad do
    title 'ordenador en Vallecas'
    body 'pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger'
    type 1
    status 1
    woeid_code 766_273
    ip '28.3.2.4'
    created_at { Time.zone.now }
    user
    published_at { created_at }

    trait(:in_mad) { woeid_code 766_273 }
    trait(:in_bar) { woeid_code 753_692 }
    trait(:in_ten) { woeid_code 773_692 }
  end

end
