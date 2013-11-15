class MessageThread < ActiveRecord::Base
  self.table_name = "threads"

  has_many :messages, :foreign_key => 'thread_id'
end
