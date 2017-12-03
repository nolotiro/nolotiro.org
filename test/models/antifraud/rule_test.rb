# frozen_string_literal: true

require 'test_helper'

module Antifraud
  class RuleTest < ActiveSupport::TestCase
    setup do
      create(:antifraud_rule, sentence: 'regalo de campista')
    end

    %w[title body].each do |col|
      test ".spam? does not fire on similar #{col}" do
        ad = create(:ad, col => 'Atencion. regalo de campera para una persona honesta')

        assert_ham(ad)
      end

      test ".spam? fires on #{col} containing exact sentence" do
        ad = create(:ad, col => 'Atencion. regalo de campista para una persona honesta')

        assert_spam(ad)
      end

      test ".spam? fires on exact #{col}" do
        ad = create(:ad, col => 'regalo de campista')

        assert_spam(ad)
      end

      test ".spam? matches #{col} case-insensitively" do
        ad = create(:ad, col => 'Atencion. Regalo de campista para una persona honesta')

        assert_spam(ad)
      end
    end

    private

    def assert_ham(ad)
      assert_equal false, Rule.spam?(ad)
      assert_no_difference('Match.count') { Rule.spam?(ad) }
    end

    def assert_spam(ad)
      assert_equal true, Rule.spam?(ad)
      assert_difference('Match.count', 1) { Rule.spam?(ad) }
    end
  end
end
