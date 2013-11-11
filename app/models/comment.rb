class Comment < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_owner' #, :counter_cache => true
  belongs_to :ad, foreign_key: 'ads_id' #, :counter_cache => true
end
