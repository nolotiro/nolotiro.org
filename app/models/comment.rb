class Comment < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_owner' #, :counter_cache => true
  belongs_to :ad, foreign_key: 'ads_id', counter_cache: true, touch: true
  
  validates :ads_id, presence: true
  validates :body, presence: true
  validates :user_owner, presence: true
  validates :ip, presence: true

  validates :body, length: {maximum: 1000}

  scope :recent, -> { includes(:ad, :user).limit(30) }

  def body 
    ApplicationController.helpers.escape_privacy_data(read_attribute(:body))
  end

end
