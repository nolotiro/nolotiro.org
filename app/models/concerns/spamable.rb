# frozen_string_literal: true

require 'active_support/concern'

#
# Spam related functionality
#
module Spamable
  extend ActiveSupport::Concern

  included do
    scope :spam, -> { where(spam: true) }
    scope :not_spam, -> { where(spam: false) }
  end

  #
  # @todo We'll want to include something more sophisticated here, like a
  # Bayesian classifier.
  #
  def check_spam!
    opinion = spammed?(title) || spammed?(body)

    update!(spam: opinion)

    opinion
  end

  def toggle_spam!
    toggle!(:spam)
  end

  private

  def spammed?(text)
    Regexp.new('regalo de campista', Regexp::IGNORECASE).match(text).present?
  end
end
