# frozen_string_literal: true

class Message < ActiveRecord::Base
  validates :sender, presence: true
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation, validate: true, autosave: true
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

  attr_writer :recipients

  def recipients
    return @recipients unless @recipients.blank?

    @recipients = receipts.includes(:receiver).map(&:receiver)
  end

  def deliver(reply = false)
    receiver_receipts = recipients.map do |r|
      receipts.build(receiver: r, mailbox_type: 'inbox', is_read: false)
    end

    sender_receipt =
      receipts.build(receiver: sender, mailbox_type: 'sentbox', is_read: true)

    if valid?
      save!
      Mailboxer::MailDispatcher.new(self, receiver_receipts).call

      conversation.touch if reply

      self.recipients = nil
    end

    sender_receipt
  end
end
