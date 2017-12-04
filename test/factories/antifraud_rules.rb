# frozen_string_literal: true

require 'antifraud'

FactoryBot.define do
  factory :antifraud_rule, class: 'Antifraud::Rule' do
    sentence 'MyText'
    activated_at { Time.zone.now }
  end
end
