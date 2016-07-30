# frozen_string_literal: true

class Message < Mailboxer::Message
  belongs_to :conversation, validate: true, autosave: true

  has_many :receipts, dependent: :destroy, foreign_key: :notification_id
end
