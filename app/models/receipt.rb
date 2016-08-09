# frozen_string_literal: true

class Receipt < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :message, foreign_key: :notification_id

  scope :recipient, ->(recipient) { where(receiver_id: recipient.id) }

  scope :untrashed, -> { where(trashed: false) }
  scope :unread, -> { untrashed.where(is_read: false) }

  def self.mark_as_read(user)
    recipient(user).update_all(is_read: true)
  end

  def self.move_to_trash(user)
    recipient(user).update_all(trashed: true)
  end
end
