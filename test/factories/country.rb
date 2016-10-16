# frozen_string_literal: true

FactoryGirl.define do
  factory :country do
    spain

    trait :spain do
      iso 'ES'
      name 'España'
    end

    trait :colombia do
      name 'Colombia'
      iso 'CO'
    end

    initialize_with { Country.find_or_initialize_by(iso: iso) }
  end
end
