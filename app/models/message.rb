# frozen_string_literal: true

class Message < ApplicationRecord
  validates :sender, presence: true, on: :create
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation
  belongs_to :sender, class_name: 'User', optional: true

  has_many :receipts,
           dependent: :destroy,
           foreign_key: :notification_id,
           inverse_of: :message

  scope :involving, ->(user) do
    joins(:receipts).merge(Receipt.recipient(user).untrashed)
  end

  scope :unread_by, ->(user) do
    joins(:receipts).merge(Receipt.recipient(user).unread)
  end

  def recipient
    conversation.interlocutor(sender)
  end

  def envelope_for(recipient)
    receipts.build(receiver: sender, is_read: true)
    receipts.build(receiver: recipient, is_read: false)
  end

  def deliver
    MessageMailer.send_email(self).deliver_now
  end
end
