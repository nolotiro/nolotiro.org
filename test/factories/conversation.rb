# frozen_string_literal: true

FactoryGirl.define do
  factory :conversation do
    transient do
      originator { create(:user) }
      recipient { create(:user) }
    end

    subject 'Talking about presents'

    after(:build) do |conversation, evaluator|
      conversation.envelope_for(sender: evaluator.originator,
                                recipient: evaluator.recipient,
                                body: 'The start of a beautiful friendship')
    end
  end
end
