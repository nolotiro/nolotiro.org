# frozen_string_literal: true

FactoryGirl.define do
  factory :report do
    ad
    association :reporter, factory: :user
  end
end
