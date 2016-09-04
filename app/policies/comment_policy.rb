# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def create?
    record.ad.comments_enabled? &&
      !record.ad.delivered? &&
      user &&
      Blocking.none_between?(record.ad.user, user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope unless user

      scope.from_unlocked_authors.from_authors_whitelisting(user)
    end
  end
end
