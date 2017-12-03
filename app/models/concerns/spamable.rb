# frozen_string_literal: true

#
# Spam related functionality
#
# @todo We'll want to include something more sophisticated here, like a Bayesian
# classifier.
#
module Spamable
  def check_spam!
    user.ban! if Antifraud::Rule.spam?(self)
  end
end
