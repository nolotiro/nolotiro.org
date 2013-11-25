class Comment < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_owner' #, :counter_cache => true
  belongs_to :ad, foreign_key: 'ads_id' #, :counter_cache => true
  
  validates :ads_id, presence: true
  validates :body, presence: true
  validates :date_created, presence: true
  validates :user_owner, presence: true
  validates :ip, presence: true

  # TODO: save user_owner automatically
  # TODO: save ip automatically
  # TODO: save date_created automatically

end
