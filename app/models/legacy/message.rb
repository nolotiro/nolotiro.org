class Legacy::Message < ActiveRecord::Base

  self.table_name = "messages_legacy" 

  belongs_to :sender, :class_name=>'User', :foreign_key=>'user_from'
  belongs_to :reciever, :class_name=>'User', :foreign_key=>'user_to'

  belongs_to :thread, :class_name=>'MessageThread', :foreign_key => 'thread_id'

  validates :thread_id, presence: true
  validates :ip, presence: true
  validates :subject, presence: true
  validates :body, presence: true
  validates :readed, presence: true
  validates :user_from, presence: true
  validates :user_to, presence: true

  def self.create_thread user_from, user_to, subject, body, ip
    th = MessageThread.create(
      subject: subject,
      last_speaker: user_from,
      user_from: user_from,
      user_to: user_to
    )
    Message.create_message(user_from, user_to, subject, body, th.id, ip)
  end

  def self.create_message user_from, user_to, subject, body, thread_id, ip
    message = Message.build(
      body: body,
      subject: subject,
      last_speaker: user_from,
      user_from: user_from,
      user_to: user_to,
      thread_id: thread_id, 
      ip: ip
    )
    th = MessageThread.find thread_id th.unread =+ 1 
    th.deleted_from = 0
    th.deleted_to = 0
    th.last_speaker = user_from
    th.save
    message
  end

  def self.get_threads_from_user(user)
    # nolotirov2 - legacy
    #
    # FIX: this is 100% legacy, now we use mailboxer
    send_threads = user.legacy_sent_messages.order('created_at DESC').limit(10).joins(:thread).group('thread_id').count
    recieved_threads = user.legacy_recieved_messages.order('created_at DESC').limit(10).joins(:thread).group('thread_id').count
    threads = []
    send_threads.keys.each do |thread|
      th = Legacy::MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == user.id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    recieved_threads.keys.each do |thread|
      th = Legacy::MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == user.id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    threads
  end

  def self.get_messages_from_thread(thread_id)
    Legacy::MessageThread.find(thread_id).messages
  end

  def self.get_unread_count(user_id)

  end

  def self.mark_as_readed(thread_id, user_id)
  end

  def self.delete_thread(thread_id)
  end

  def get_conversation
    from = self.user_from.nil? ? User.find_by_username("[borrado]").id : self.user_from
    to = self.user_to.nil? ? User.find_by_username("[borrado]").id : self.user_to

    subject = self.thread.subject
    # 1. Busca todos los Receipts por receiver_id basandose en el user_from y user_to del MessageLegacy
    # Agrupa todos sus Receipts por los notification_id que los dos tienen
    # (si dos usuarios tienen el mismo notification_id tuvieron una conversación)
    #notification_ids = Mailboxer::Receipt.where("receiver_id=? OR receiver_id=?", from, to).distinct.count(group: :notification_id).select{|k,v| v > 1}.keys 
    notification_ids = Mailboxer::Receipt.where("receiver_id=? OR receiver_id=?", from, to).distinct.group(:notification_id).count.keys
    # 2. De ese resultado filtramos los que coincidan con el Subject, devolvemos la Conversation
    notification_ids.each do |n|
      notification = Mailboxer::Notification.find_by_id n
      if notification.subject == subject
        return notification.conversation 
      else 
        next 
      end
      #res = notification.subject == subject ? notification.conversation : nil
      # 
    end
  end

  def reply_to_conversation(conversation, from_u)
    # It isn't the first, so the Conversation is already there
    if body != ""
      r = from_u.reply_to_conversation(conversation, self.body.force_encoding('UTF-8'))
      r.created_at = self.created_at 
      r.updated_at = self.created_at 
      r.message.created_at = self.created_at 
      r.message.updated_at = self.created_at 
      r.message.save
      r.save
      self.update_attribute(:is_migrated, true)
    end
  end

  def start_or_reply_conversation

    Mailboxer.setup do |config|
      config.uses_emails = false
    end

    message = self

    unless message.is_migrated 

      message_thread = message.thread

      # nolotirov2 legacy 
      # FIX: hay algunos mensajes que no tienen un user_from (bug legacy)
      #
      # buscamos al usuario y si no lo tiene o es nil lo ponemos como User [borrado]
      #
      # FIX: undefined method `send_message' for nil:NilClass  '
      from_u = message.sender.nil? ? User.find_by_username("[borrado]") : message.sender
      to_u = message.reciever.nil? ? User.find_by_username("[borrado]") : message.reciever

      if message_thread

        message_thread.messages.each do |m|
          if m ==  message_thread.messages.first
            #puts "START conversation..."
            from_u = m.sender.nil? ? User.find_by_username("[borrado]") : m.sender
            to_u = m.reciever.nil? ? User.find_by_username("[borrado]") : m.reciever
            r = from_u.send_message(to_u, m.body, message_thread.subject, true, nil, m.created_at)
            r.conversation.update_attribute(:thread_id, message_thread.id)
            m.update_attribute(:is_migrated, true)
            m.thread.update_attribute(:conversation_id, r.conversation.id)
          else
            conversation = m.get_conversation
            #conversation = Conversation.find_by_subject message_thread.subject
            unless conversation == [] or conversation.nil?
              from_u = m.sender.nil? ? User.find_by_username("[borrado]") : m.sender
              to_u = m.reciever.nil? ? User.find_by_username("[borrado]") : m.reciever
              #puts "REPLY conversation..."
              m.reply_to_conversation(conversation, from_u)
            else
              raise "******************* INVALID CONVERSATION - maybe it isnt well ordered? - messages #{m.id} *********************"
            end
          end
        end
      else
      # FIX: if there isn't a thread for this message, then we start the conversation'
      #
      #  puts "NO THREAD - NEW conversation..."
      #  puts message.id
        r = from_u.send_message(to_u, message.body, message.subject, true, nil, message.created_at)
        r.conversation.update_attribute(:thread_id, 999999999) # mismo numero para diferenciarlos
        message.update_attribute(:is_migrated, true)
      end

    else 
      puts "ALREADY MIGRATED conversation..., #{message.id} -  http://localhost:3000/es/legacy/message/show/#{message.thread.id}/subject/#{message.thread.subject}"
    end
  end

end
