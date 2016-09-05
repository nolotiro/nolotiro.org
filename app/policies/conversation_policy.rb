# frozen_string_literal: true

class ConversationPolicy < ApplicationPolicy
  def create?
    sender && recipient && user == sender && no_blockings?
  end

  def update?
    sender && recipient && user == sender && no_blockings?
  end

  def show?
    return true unless interlocutor

    interlocutor.whitelisting?(user)
  end

  private

  def interlocutor
    @interlocutor ||= record.interlocutor(user)
  end

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
