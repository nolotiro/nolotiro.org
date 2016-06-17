# frozen_string_literal: true

#
# Blockings between users
#
class Blocking < ActiveRecord::Base
  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'

  validates :blocker, :blocked, presence: true
  validates :blocker, uniqueness: { scope: :blocked }
end
