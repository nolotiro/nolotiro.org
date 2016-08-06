# frozen_string_literal: true

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, :friend, presence: true
  validates :friend, uniqueness: { scope: :user }
end
