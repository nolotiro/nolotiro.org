# frozen_string_literal: true

class Conversation < ActiveRecord::Base
  validates :subject, presence: true, length: { maximum: 255 }

  has_many :messages, dependent: :destroy
  has_many :receipts, through: :messages

  scope :involving, ->(user) do
    joins(:receipts).merge(Receipt.involving(user).untrashed).distinct
  end

  scope :unread, ->(user) do
    joins(:receipts).merge(Receipt.involving(user).unread).distinct
  end

  def envelope_for(sender:, recipient:, body: '')
    self.updated_at = Time.zone.now

    message = messages.build(sender: sender, body: body)

    message.envelope_for(recipient)

    message
  end

  def interlocutor(user)
    received_receipts = receipts.where.not(receiver_id: user.id)
    return received_receipts.first.receiver if received_receipts.any?

    return if receipts.size == 1

    receipts.first.receiver
  end

  def originator
    original_message.sender
  end

  def original_message
    @original_message ||= messages.order(:created_at).first
  end

  def messages_for(user)
    messages.involving(user)
  end

  def last_message
    @last_message ||= messages.last
  end

  def unread?(user)
    messages.unread(user).any?
  end

  delegate :mark_as_read, :move_to_trash, to: :receipts
end
