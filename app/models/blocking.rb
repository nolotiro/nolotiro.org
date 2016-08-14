# frozen_string_literal: true

#
# Blockings between users
#
class Blocking < ActiveRecord::Base
  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'

  validates :blocker, :blocked, presence: true
  validates :blocker, uniqueness: { scope: :blocked }

  def self.none_between?(user1, user2)
    condition = <<-SQL.squish
      (blocker_id = :uid1 AND blocked_id = :uid2) OR
      (blocker_id = :uid2 AND blocked_id = :uid1)
    SQL

    where(condition, uid1: user1.id, uid2: user2.id).none?
  end
end
