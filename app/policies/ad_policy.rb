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
      return scope unless user

      scope.from_authors_whitelisting(user)
    end
  end
end
