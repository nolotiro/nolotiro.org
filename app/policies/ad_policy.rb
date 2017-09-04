# frozen_string_literal: true

class AdPolicy < ApplicationPolicy
  def update?
    user && (record.user == user || user.admin?)
  end

  def bump?
    user && (record.user == user && record.bumpable?)
  end

  def change_status?
    user && record.give? && record.user == user
  end

  def destroy?
    user && (record.user == user || user.admin?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      not_spam = scope.from_legitimate_authors
      return not_spam unless user

      not_spam.from_authors_whitelisting(user)
    end
  end
end
