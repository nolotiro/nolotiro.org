class Message < ActiveRecord::Base

  belongs_to :sender, :class_name=>'User', :foreign_key=>'user_from'
  belongs_to :reciever, :class_name=>'User', :foreign_key=>'user_to'

  belongs_to :thread, :class_name=>'MessageThread', :foreign_key => 'thread_id'

  validates :thread_id, presence: true
  validates :date_created, presence: true
  validates :ip, presence: true
  validates :subject, presence: true
  validates :body, presence: true
  validates :readed, presence: true
  validates :user_from, presence: true
  validates :user_to, presence: true

end
