# frozen_string_literal: true

FactoryGirl.define do
  factory :town do
    madrid

    trait :madrid do
      transient do
        _state :madrid
        _country :spain
      end

      id 766_273
      name 'Madrid'
    end

    trait :barcelona do
      transient do
        _state :catalonia
        _country :spain
      end

      id 753_692
      name 'Barcelona'
    end

    trait :tenerife do
      transient do
        _state :canary_islands
        _country :spain
      end

      id 773_692
      name 'Santa Cruz de Tenerife'
    end

    country { create(:country, _country) }
    state { create(:state, _state) }

    initialize_with { Town.find_or_initialize_by(id: id) }
  end
end
