# frozen_string_literal: true

FactoryGirl.define do
  factory :message do
    transient do
      recipient { create(:user) }
    end

    association :sender, factory: :user

    conversation

    body 'The start of a beautiful friendship'

    after(:build) do |message, evaluator|
      message.envelope_for(evaluator.recipient)
    end
  end
end
