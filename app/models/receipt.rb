# frozen_string_literal: true

class Receipt < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :message, foreign_key: :notification_id

  scope :recipient, ->(recipient) { where(receiver_id: recipient.id) }

  scope :not_trash, -> { where(trashed: false) }
  scope :unread, -> { where(is_read: false) }

  scope :conversation, ->(conversation) do
    joins(:message).where(messages: { conversation_id: conversation.id })
  end
end
