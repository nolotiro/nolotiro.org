# frozen_string_literal: true

FactoryGirl.define do
  factory :dismissal do
    user
    announcement
  end
end
