class Comment < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_owner' #, :counter_cache => true
  belongs_to :ad, foreign_key: 'ads_id' #, :counter_cache => true
  
  validates :presence, :ads_id, :body, :date_created, :user_owner, :ip

  # TODO: save user_owner automatically
  # TODO: save ip automatically
  # TODO: save date_created automatically

end
