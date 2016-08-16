# frozen_string_literal: true

class Receipt < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :message, foreign_key: :notification_id

  scope :recipient, ->(recipient) { where(receiver_id: recipient.id) }

  scope :untrashed_by, ->(user) { involving(user).untrashed }
  scope :unread_by, ->(user) { involving(user).unread }

  scope :untrashed, -> { where(trashed: false) }
  scope :unread, -> { untrashed.where(is_read: false) }

  scope :involving, ->(user) do
    joined = joins <<-SQL.squish
      LEFT OUTER JOIN receipts s
      ON s.notification_id = receipts.notification_id AND s.id <> receipts.id
      LEFT OUTER JOIN blockings b
      ON (receipts.receiver_id = b.blocker_id AND s.receiver_id = b.blocked_id)
      OR (receipts.receiver_id = b.blocked_id AND s.receiver_id = b.blocker_id)
    SQL

    joined.recipient(user).where('b.id IS NULL OR b.blocker_id = ?', user.id)
  end

  def self.mark_as_read(user)
    recipient(user).update_all(is_read: true)
  end

  def self.move_to_trash(user)
    recipient(user).update_all(trashed: true)
  end
end
