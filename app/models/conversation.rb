# frozen_string_literal: true

class Conversation < Mailboxer::Conversation
  def interlocutor(user)
    received_receipts = receipts.where.not(receiver_id: user.id)
    return unless received_receipts.any?

    received_receipts.first.receiver
  end
end
