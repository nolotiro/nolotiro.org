# frozen_string_literal: true

module Antifraud
  class Rule < ApplicationRecord
    has_many :matches, foreign_key: :antifraud_rule_id, dependent: :destroy, inverse_of: :antifraud_rule
    has_many :matched_ads, through: :matches, source: :ad

    def self.spam?(ad)
      matching_rules = Rule.select { |rule| rule.matches?(ad) }
      return false unless matching_rules.any?

      matching_rules.each { |rule| rule.matches.create(ad: ad) }
      true
    end

    def matches?(ad)
      regexp.match?(ad.title) || regexp.match?(ad.body)
    end

    private

    def regexp
      @regexp ||= Regexp.new(sentence, Regexp::IGNORECASE)
    end
  end
end
