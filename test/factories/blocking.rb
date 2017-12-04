# frozen_string_literal: true

FactoryBot.define do
  factory :blocking do
    association :blocker, factory: :user
    association :blocked, factory: :user
  end
end
