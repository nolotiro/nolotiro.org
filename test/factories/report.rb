# frozen_string_literal: true

FactoryGirl.define do
  factory :report do
    association :reporter, factory: :user
    association :reported, factory: :user
  end
end
