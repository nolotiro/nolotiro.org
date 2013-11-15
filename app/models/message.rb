class Message < ActiveRecord::Base

  belongs_to :sender, :class_name=>'User', :foreign_key=>'user_from'
  belongs_to :reciever, :class_name=>'User', :foreign_key=>'user_to'

  belongs_to :thread, :class_name=>'MessageThread', :foreign_key => 'thread_id'
end
