# frozen_string_literal: true

class ConversationPolicy < ApplicationPolicy
  def create?
    sender && recipient && user == sender && no_blockings?
  end

  def update?
    sender && recipient && user == sender && no_blockings?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.with_legitimate_participants
           .participant(user)
           .whitelisted_for(user)
           .untrashed_by(user)
    end
  end

  private

  def no_blockings?
    Blocking.none_between?(sender, recipient)
  end

  def recipient
    record.last_message.recipient
  end

  def sender
    record.last_message.sender
  end
end
