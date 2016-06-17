# frozen_string_literal: true

require 'active_support/concern'

module Hidable
  extend ActiveSupport::Concern

  included do
    scope :from_authors_whitelisting, ->(user) do
      joins(:user).merge(User.whitelisting(user))
    end
  end
end
