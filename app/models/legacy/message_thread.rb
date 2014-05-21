class Legacy::MessageThread < ActiveRecord::Base
  self.table_name = "threads"

  has_many :messages, :foreign_key => 'thread_id'

  def other_user user
    user == self.first_sender ? self.first_reciever : self.first_sender
  end

  def first_sender
    self.messages.first.reciever
  end

  def first_reciever
    self.messages.first.sender
  end

  def check_readed user
    self.messages.each do |m|
      unless m.readed? 
        if user == m.reciever
          m.update_attribute(:readed, 1)
        end
      end
    end
  end

  def unreaded_messages_count 
    self.messages.where(readed: 0).count
  end

end
