# frozen_string_literal: true

class Conversation < ActiveRecord::Base
  validates :subject, presence: true, length: { maximum: 255 }

  has_many :messages
  has_many :receipts, through: :messages

  scope :involving, ->(user) do
    joins(:receipts)
      .order(updated_at: :desc)
      .merge(Receipt.recipient(user))
      .distinct
  end

  scope :untrashed, ->(user) { involving(user).merge(Receipt.untrashed) }

  scope :unread, ->(user) { involving(user).merge(Receipt.unread) }

  def envelope_for(sender:, recipient:, body: '')
    message = messages.build(sender: sender, body: body)

    message.envelope_for(recipient)

    message
  end

  def interlocutor(user)
    received_receipts = receipts.where.not(receiver_id: user.id)
    return unless received_receipts.any?

    received_receipts.first.receiver
  end

  def originator
    original_message.sender
  end

  def original_message
    @original_message ||= messages.order(:created_at).first
  end

  def messages_for(user)
    messages.untrashed(user)
  end

  def unread?(user)
    receipts_for(user).untrashed.unread.count != 0
  end

  def mark_as_read(user)
    receipts_for(user).update_all(is_read: true)
  end

  def move_to_trash(user)
    receipts_for(user).update_all(trashed: true)
  end

  def receipts_for(user)
    Receipt.conversation(self).recipient(user)
  end
end
