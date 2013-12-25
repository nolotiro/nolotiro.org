class User < ActiveRecord::Base

  has_many :ads, foreign_key: 'user_owner'
  has_many :comments, foreign_key: 'user_owner'

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :sent_messages, :class_name=> 'Message', :foreign_key=>'user_from', :dependent=>:destroy
  has_many :recieved_messages, :class_name=> 'Message', :foreign_key=>'user_to', :dependent=>:destroy

  before_save :default_lang

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def admin?
    role == 1
  end

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super and self.locked != 1
  end

  def unlock!
    self.locked = 0
    self.save
  end

  def lock!
    self.locked = 1
    self.save
  end

  def default_lang
    self.lang ||= "es"
  end

  # nolotirov2 legacy: messaging
  def last_threads
    # 100% legacy, from the DB we had
    # FIXME: PLEEAAASEE migrate me to mailboxer or something more Rails like
    send_threads = sent_messages.order('date_created DESC').limit(10).joins(:thread).group('thread_id').count
    recieved_threads = recieved_messages.order('date_created DESC').limit(10).joins(:thread).group('thread_id').count
    threads = []
    send_threads.keys.each do |thread|
      th = MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    recieved_threads.keys.each do |thread|
      th = MessageThread.find(thread.to_i)
      other_user = th.messages.first.user_from == id ? th.messages.first.reciever : th.messages.first.sender
      threads.append([th, other_user])
    end
    threads
  end

  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database 
  def valid_password?(password)
    if self.legacy_password_hash.present?
      if ::Digest::MD5.hexdigest(password).upcase == self.legacy_password_hash.upcase
        self.password = password
        self.legacy_password_hash = nil
        self.save!
        true
      else
        false
      end
    else
      super
    end
  end

  def reset_password!(*args)
    self.legacy_password_hash = nil
    super
  end

end
