# frozen_string_literal: true

FactoryBot.define do
  factory :dismissal do
    user
    announcement
  end
end
