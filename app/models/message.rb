# frozen_string_literal: true

class Message < ActiveRecord::Base
  validates :sender, presence: true
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

  scope :untrashed, ->(user) do
    joins(:receipts).merge(Receipt.recipient(user).untrashed)
  end

  scope :unread, ->(user) { untrashed(user).merge(Receipt.unread) }

  def recipient_receipt
    receipts.find_by(mailbox_type: 'inbox')
  end

  def recipient
    recipient_receipt.receiver
  end

  def envelope_for(recipient)
    receipts.build(receiver: sender, mailbox_type: 'sent', is_read: true)
    receipts.build(receiver: recipient, mailbox_type: 'inbox', is_read: false)
  end

  def deliver
    Mailboxer::MailDispatcher.new(self, [recipient_receipt]).call
  end
end
