# frozen_string_literal: true

class Message < ActiveRecord::Base
  validates :sender, presence: true, on: :create
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

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
    receipts.build(receiver: sender, mailbox_type: 'sent', is_read: true)
    receipts.build(receiver: recipient, mailbox_type: 'inbox', is_read: false)
  end

  def deliver
    Mailboxer::MessageMailer.send_email(self, recipient).deliver_now
  end
end
