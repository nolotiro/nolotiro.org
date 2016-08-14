# frozen_string_literal: true
FactoryGirl.define do
  factory :friendship do
    user
    association :friend, factory: :user
  end
end
