# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    association :reporter, factory: :user
    association :reported, factory: :user
  end
end
