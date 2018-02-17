# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User", inverse_of: :incoming_friendships

  validates :user, :friend, presence: true
  validates :friend, uniqueness: { scope: :user }
end
