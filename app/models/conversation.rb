# frozen_string_literal: true

class Conversation < ActiveRecord::Base
  validates :subject, presence: true, length: { maximum: 255 }

  has_many :messages, dependent: :destroy
  has_many :receipts, through: :messages

  belongs_to :originator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  scope :untrashed_by, ->(user) do
    joins(:receipts).merge(Receipt.untrashed_by(user)).distinct
  end

  scope :unread_by, ->(user) do
    joins(:receipts).merge(Receipt.unread_by(user)).distinct
  end

  scope :participant, ->(user) do
    where('recipient_id = ? OR originator_id = ?', user.id, user.id)
  end

  scope :whitelisted_for, ->(user) do
    joined = joins <<-SQL.squish
      LEFT OUTER JOIN blockings
      ON (recipient_id = blocker_id AND originator_id = blocked_id) OR
         (recipient_id = blocked_id AND originator_id = blocker_id)
    SQL

    joined.merge(Blocking.not_affecting(user))
  end

  scope :with_legitimate_participants, -> do
    joined = joins <<-SQL.squish
      LEFT OUTER JOIN users u1 ON conversations.originator_id = u1.id
      LEFT OUTER JOIN users u2 ON conversations.recipient_id = u2.id
    SQL

    joined.where('u1.banned_at IS NULL AND u2.banned_at IS NULL')
  end

  def self.start(sender:, recipient:, subject: '', body: '')
    conversation = new(subject: subject,
                       originator_id: sender.id,
                       recipient_id: recipient.id)

    conversation.envelope_for(sender: sender, recipient: recipient, body: body)

    conversation
  end

  def envelope_for(sender:, recipient:, body: '')
    message = messages.build(sender: sender, body: body)

    message.envelope_for(recipient)

    message
  end

  def reply(sender:, recipient:, body: '')
    self.updated_at = Time.zone.now

    envelope_for(sender: sender, recipient: recipient, body: body)
  end

  def interlocutor(user)
    user == originator ? recipient : originator
  end

  def messages_for(user)
    messages.involving(user)
  end

  def last_message
    @last_message ||= messages.last
  end

  delegate :mark_as_read, :move_to_trash, to: :receipts
end
