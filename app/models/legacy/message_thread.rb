class Legacy::MessageThread < ActiveRecord::Base
  self.table_name = "threads"

  has_many :messages, :foreign_key => 'thread_id'
  has_one :conversation, class_name: Mailboxer::Conversation, :foreign_key => 'thread_id'

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

  def migrate!
    # disable mailboxer email for migration from legacy
    Mailboxer.setup { |config| config.uses_emails = false }

    # for every message in this thread
    thread = self
    thread.messages.each_with_index do |message, idx|
      # that isn't migrated
      if !message.is_migrated 
        # stop if any message has body or subject empty
        break if message.body.empty? 
        break if message.sender.nil? 
        # if its the first, initialize the conversation
        if idx == 0
          begin 
            receipt = message.sender.send_message(message.reciever, message.body, thread.subject, true, nil, message.created_at)
          rescue 
            debugger
          end
          # mark it as migrated
          message.update_attribute(:is_migrated, true)
          # stablish relation  conversation -> legacy_thread
          receipt.conversation.update_attribute(:thread_id, thread.id)
          # stablish relation  legacy_thread -> conversation 
          thread.update_attribute(:conversation_id, receipt.conversation.id)
        # but if isnt the first, then we reply to the conversation
        else
          # find the conversation id for this thread (setted up when creating the conversation)
          conversation = Mailboxer::Conversation.find( thread.conversation_id ) 
          # see Legacy::Message.reply_to_conversation
          message.reply_to_conversation( conversation, message.sender ) 
        end
      end
    end
  end

end
