# frozen_string_literal: true

FactoryGirl.define do
  factory :state do
    madrid

    trait :madrid do
      transient { _country :spain }

      name 'Madrid'
      id 12_578_024
    end

    trait :catalonia do
      transient { _country :spain }

      id 12_578_034
      name 'Catalunya'
    end

    trait :canary_islands do
      transient { _country :spain }

      id 12_578_031
      name 'Islas Canarias'
    end

    trait :magdalena do
      transient { _country :colombia }

      id 2_345_063
      name 'Magdalena'
    end

    trait :cordoba do
      transient { _country :colombia }

      id 2_345_058
      name 'Cordoba'
    end

    country { create(:country, _country) }

    initialize_with { State.find_or_initialize_by(id: id) }
  end
end
