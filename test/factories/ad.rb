# frozen_string_literal: true

FactoryGirl.define do
  factory :ad do
    title 'ordenador en Vallecas'
    body 'pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger'
    give
    available
    woeid_code 766_273
    ip '28.3.2.4'
    created_at { Time.zone.now }
    user
    published_at { created_at }

    trait :give do
      type :give
      status :available
    end

    trait :want do
      type :want
      status nil
    end

    trait :available do
      give
      status :available
    end

    trait :booked do
      give
      status :booked
    end

    trait :delivered do
      give
      status :delivered
    end

    trait :expired do
      published_at { 32.days.ago }
    end

    trait(:in_mad) { woeid_code 766_273 }
    trait(:in_bar) { woeid_code 753_692 }
    trait(:in_ten) { woeid_code 773_692 }
  end
end
