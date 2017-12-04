# frozen_string_literal: true

#
# Spam related functionality
#
# @todo We'll want to include something more sophisticated here, like a Bayesian
# classifier.
#
module Spamable
  extend ActiveSupport::Concern

  included do
    has_many :fraud_matches, class_name: 'Antifraud::Match', dependent: :destroy, inverse_of: :ad
    has_many :fraud_matched_rules, through: :fraud_matches, source: :antifraud_rule
  end

  def check_spam!
    user.ban! if Antifraud::Rule.spam?(self)
  end
end
