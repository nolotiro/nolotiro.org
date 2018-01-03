# frozen_string_literal: true

#
# Blockings between users
#
class Blocking < ApplicationRecord
  belongs_to :blocker, class_name: 'User', inverse_of: :blockings
  belongs_to :blocked, class_name: 'User', inverse_of: :received_blockings

  validates :blocker, :blocked, presence: true
  validates :blocker, uniqueness: { scope: :blocked }

  scope :not_affecting, ->(user) do
    where('blockings.blocked_id IS NULL OR blockings.blocked_id <> ?', user.id)
  end

  def self.none_between?(user1, user2)
    condition = <<-SQL.squish
      (blocker_id = :uid1 AND blocked_id = :uid2) OR
      (blocker_id = :uid2 AND blocked_id = :uid1)
    SQL

    where(condition, uid1: user1.id, uid2: user2.id).none?
  end
end
