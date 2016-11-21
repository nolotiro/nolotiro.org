# frozen_string_literal: true

class Comment < ActiveRecord::Base
  include Censurable
  censors :body

  include Hidable
  include Statable

  counter_stats_for :created_at

  belongs_to :user, foreign_key: :user_owner
  belongs_to :ad, foreign_key: :ads_id

  validates :ads_id, presence: true
  validates :body, presence: true
  validates :user_owner, presence: true
  validates :ip, presence: true

  validates :body, length: { maximum: 1000 }

  scope :recent, -> { includes(:ad, :user).order(created_at: :desc).limit(30) }

  scope :oldest_first, -> { order(created_at: :asc) }
end
