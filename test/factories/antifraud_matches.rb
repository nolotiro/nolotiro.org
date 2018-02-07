# frozen_string_literal: true

FactoryBot.define do
  factory :antifraud_match, class: 'Antifraud::Match' do
    antifraud_rule nil
    ad nil
  end
end
