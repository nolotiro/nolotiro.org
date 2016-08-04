# frozen_string_literal: true

class Message < ActiveRecord::Base
  validates :sender, presence: true
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation, validate: true, autosave: true
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

  attr_writer :recipient

  def recipient
    @recipient ||= receipts.find_by(mailbox_type: 'inbox').receiver
  end

  def deliver(reply = false)
    recipient_receipt =
      receipts.build(receiver: recipient, mailbox_type: 'inbox', is_read: false)

    receipts.build(receiver: sender, mailbox_type: 'sentbox', is_read: true)

    return unless save

    Mailboxer::MailDispatcher.new(self, [recipient_receipt]).call

    conversation.touch if reply

    self.recipient = nil
  end
end
