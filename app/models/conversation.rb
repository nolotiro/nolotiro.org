# frozen_string_literal: true

class Conversation < Mailboxer::Conversation
  has_many :messages

  scope :participant, ->(user) do
    where(mailboxer_notifications: { type: 'Message' })
      .order(updated_at: :desc)
      .joins(:receipts)
      .merge(Receipt.recipient(user))
      .distinct
  end

  scope :not_trash, ->(user) { participant(user).merge(Receipt.not_trash) }

  def interlocutor(user)
    received_receipts = receipts.where.not(receiver_id: user.id)
    return unless received_receipts.any?

    received_receipts.first.receiver
  end
end
