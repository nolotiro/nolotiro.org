# frozen_string_literal: true

class AdPolicy < ApplicationPolicy
  def update?
    user && (record.user == user || user.admin?)
  end

  def bump?
    user && ((record.user == user && record.bumpable?) || user.admin?)
  end

  def destroy?
    user && (record.user == user || user.admin?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      not_spam = scope.not_spam
      return not_spam unless user

      not_spam.from_unlocked_authors.from_authors_whitelisting(user)
    end
  end
end
