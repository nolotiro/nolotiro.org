# frozen_string_literal: true

class Message < ActiveRecord::Base
  self.table_name = 'mailboxer_notifications'

  validates :sender, presence: true
  validates :body, presence: true, length: { maximum: 32_000 }

  belongs_to :conversation, validate: true, autosave: true
  belongs_to :sender, class_name: 'User'

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id

  scope :not_trashed_by, ->(user) do
    joins(:receipts).merge(Receipt.recipient(user).not_trash)
  end

  attr_writer :recipients

  def recipients
    return Array.wrap(@recipients) unless @recipients.blank?

    recipients  = receipts.includes(:receiver).map(&:receiver)

    @recipients = Mailboxer::RecipientFilter.new(self, recipients).call
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
