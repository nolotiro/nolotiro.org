# frozen_string_literal: true
class ConversationPolicy < ApplicationPolicy
  def create?
    user == sender && no_blockings?
  end

  def update?
    user == sender && no_blockings?
  end

  def show?
    record.interlocutor(user).whitelisting?(user)
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
