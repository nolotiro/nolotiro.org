class User < ActiveRecord::Base

  has_many :ads, foreign_key: 'user_owner'
  has_many :comments, foreign_key: 'user_owner'

  has_many :friendships
  has_many :friends, :through => :friendships

  before_save :default_lang

  has_many :legacy_sent_messages, :class_name=> 'Legacy::Message', :foreign_key=>'user_from', :dependent=>:destroy
  has_many :legacy_recieved_messages, :class_name=> 'Legacy::Message', :foreign_key=>'user_to', :dependent=>:destroy

  validates :username,
    uniqueness: true,
    length: { minimum: 3 }

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :async, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable, 
    :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  acts_as_messageable

  def self.from_omniauth(auth) 
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20] 
      user.username = auth.info.name
      user.confirm!
    end
  end

  def name
    username
  end

  def to_s
    username
  end

  def mailboxer_email(object)
    email
  end

  def unread_messages_count 
    self.mailbox.inbox.unread(self).count
  end

  def admin?
    role == 1
  end

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super and self.locked != 1
  end

  def unlock!
    self.update_column('locked', 0)
  end

  def lock!
    self.update_column('locked', 1)
  end

  def default_lang
    self.lang ||= "es"
  end

  def is_friend? user
    self.friends.where(id: user.id).count > 0 ? true : false
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
