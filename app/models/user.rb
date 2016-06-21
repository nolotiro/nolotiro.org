class User < ActiveRecord::Base
  has_many :identities, inverse_of: :user, dependent: :destroy

  has_many :ads, foreign_key: 'user_owner', dependent: :destroy
  has_many :comments, foreign_key: 'user_owner', dependent: :destroy

  has_many :friendships
  has_many :friends, :through => :friendships

  before_save :default_lang

  validates :username, presence: true, uniqueness: true, length: { maximum: 63 }

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable, 
    :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  acts_as_messageable

  scope :last_week, lambda { where("created_at >= :date", :date => 1.week.ago) } 

  scope :top_overall, ->(limit = 20) do
    select("users.id, users.username, COUNT(ads.id) as n_ads")
      .joins(:ads)
      .merge(Ad.give)
      .group("ads.user_owner")
      .unscope(:order)
      .order("n_ads DESC")
      .limit(limit)
  end

  scope :top_last_week, ->(limit = 20) do
    top_overall(limit).where("published_at >= :date", date: 1.week.ago)
  end

  def self.new_with_session(params, session)
    oauth_session = session['devise.omniauth_data']
    return super unless oauth_session

    oauth = OmniAuth::AuthHash.new(oauth_session)

    new do |u|
      u.email = params[:email]
      u.username = params[:username] || oauth.info.name
      u.identities.build(provider: oauth.provider, uid: oauth.uid)
    end
  end

  def password_required?
    super && identities.none?
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


  def reset_password(*args)
    self.legacy_password_hash = nil
    super
  end

end
