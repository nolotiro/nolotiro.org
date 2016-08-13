# frozen_string_literal: true
class Comment < ActiveRecord::Base
  include Hidable

  belongs_to :user, foreign_key: 'user_owner'
  belongs_to :ad, foreign_key: 'ads_id'

  validates :ads_id, presence: true
  validates :body, presence: true
  validates :user_owner, presence: true
  validates :ip, presence: true

  validates :body, length: { maximum: 1000 }

  scope :recent, -> { includes(:ad, :user).order(created_at: :desc).limit(30) }

  def body
    ApplicationController.helpers.escape_privacy_data(self[:body])
  end
end
