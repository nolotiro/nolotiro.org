# frozen_string_literal: true
FactoryGirl.define do
  factory :announcement do
    transient { dismisser nil }

    message 'hello world'
    starts_at { 1.hour.ago }
    ends_at { 1.hour.from_now }

    trait :acknowledged do
      after(:create) do |announcement, evaluator|
        announcement.dismissals.create!(user: evaluator.dismisser)
      end
    end
  end
end
