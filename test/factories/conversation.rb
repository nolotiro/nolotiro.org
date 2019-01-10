# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    association :originator, factory: :user
    association :recipient, factory: :user

    subject { "Talking about presents" }

    after(:build) do |conversation, evaluator|
      conversation.envelope_for(sender: evaluator.originator,
                                recipient: evaluator.recipient,
                                body: "The start of a beautiful friendship")
    end
  end
end
