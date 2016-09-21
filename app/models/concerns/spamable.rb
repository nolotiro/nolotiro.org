# frozen_string_literal: true

#
# Spam related functionality
#
# @todo We'll want to include something more sophisticated here, like a Bayesian
# classifier.
#
module Spamable
  def self.included(base)
    base.class_eval do
      scope :spam, -> { where(spam: true) }
      scope :not_spam, -> { where(spam: false) }
    end
  end

  def check_spam!
    user.ban! if spammed?(title) || spammed?(body)
  end

  private

  def spammed?(text)
    Regexp.new('regalo de campista', Regexp::IGNORECASE).match(text).present?
  end
end
