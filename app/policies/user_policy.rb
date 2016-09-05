# frozen_string_literal: true

#
# User authorization policy
#
class UserPolicy < ApplicationPolicy
  def profile?
    user.nil? || record.whitelisting?(user)
  end

  def listads?
    user.nil? || record.whitelisting?(user)
  end
end
