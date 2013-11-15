class User < ActiveRecord::Base

  has_many :ads, foreign_key: 'user_owner'
  has_many :comments, foreign_key: 'user_owner'

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :sent_messages, :class_name=> 'Message', :foreign_key=>'user_from', :dependent=>:destroy
  has_many :recieved_messages, :class_name=> 'Message', :foreign_key=>'user_to', :dependent=>:destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def admin?
    role == 1
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
