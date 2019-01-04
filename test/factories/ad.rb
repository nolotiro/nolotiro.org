# frozen_string_literal: true

FactoryBot.define do
  factory :ad do
    title "ordenador en Vallecas"
    body "pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger"
    give
    available
    in_mad
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

    trait :in_mad do
      town { create(:town, :madrid) }
    end

    trait :in_bar do
      town { create(:town, :barcelona) }
    end

    trait :in_ten do
      town { create(:town, :tenerife) }
    end
  end
end
