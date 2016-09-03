# frozen_string_literal: true
FactoryGirl.define do
  factory :blocking do
    association :blocker, factory: :user
    association :blocked, factory: :user
  end
end
