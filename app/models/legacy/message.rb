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
    # 100% legacy, from the DB we had
    # FIXME: PLEEAAASEE migrate me to mailboxer or something more Rails like
    send_threads = user.sent_messages.order('created_at DESC').limit(10).joins(:thread).group('thread_id').count
    recieved_threads = user.recieved_messages.order('created_at DESC').limit(10).joins(:thread).group('thread_id').count
    threads = []
    send_threads.keys.each do |thread|
      th = MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == user.id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    recieved_threads.keys.each do |thread|
      th = MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == user.id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    threads
  end

  def self.get_messages_from_thread(thread_id)
    MessageThread.find(thread_id).messages
  end

  def self.get_unread_count(user_id)

  end

  def self.mark_as_readed(thread_id, user_id)
  end

  def self.delete_thread(thread_id)
  end

end
