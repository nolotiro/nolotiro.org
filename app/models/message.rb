# frozen_string_literal: true

class Message < ActiveRecord::Base
  validates :sender, presence: true
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

  def recipient_receipt
    receipts.find_by(mailbox_type: 'inbox')
  end

  def recipient
    recipient_receipt.receiver
  end

  def deliver
    Mailboxer::MailDispatcher.new(self, [recipient_receipt]).call
  end
end
