# frozen_string_literal: true

class Conversation < ActiveRecord::Base
  validates :subject, presence: true, length: { maximum: 255 }

  has_many :messages
  has_many :receipts, through: :messages

  scope :involving, ->(user) do
    joins(:receipts)
      .order(updated_at: :desc)
      .merge(Receipt.recipient(user).untrashed)
      .distinct
  end

  scope :unread, ->(user) { involving(user).merge(Receipt.unread) }

  def envelope_for(sender:, recipient:, body: '')
    self.updated_at = Time.zone.now

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
    messages.unread(user).count != 0
  end

  delegate :mark_as_read, :move_to_trash, to: :receipts
end
