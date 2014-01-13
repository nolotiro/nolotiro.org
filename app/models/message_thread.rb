class MessageThread < ActiveRecord::Base
  self.table_name = "threads"

  has_many :messages, :foreign_key => 'thread_id'

  def other_user user
    user == first_sender ? first_reciever : first_sender
  end

  def first_sender
    messages.first.reciever
  end

  def first_reciever
    messages.first.sender
  end

end
