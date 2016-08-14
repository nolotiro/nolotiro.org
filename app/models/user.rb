# frozen_string_literal: true
class User < ActiveRecord::Base
  has_many :identities, inverse_of: :user, dependent: :destroy

  has_many :ads, foreign_key: 'user_owner', dependent: :destroy
  has_many :comments, foreign_key: 'user_owner', dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :receipts, as: :receiver, dependent: :destroy

  has_many :blockings, class_name: 'Blocking',
                       foreign_key: 'blocker_id',
                       dependent: :destroy

  before_save :default_lang

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { maximum: 63 }

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  scope :last_week, -> { where('created_at >= :date', date: 1.week.ago) }

  scope :top_overall, ->(limit = 20) do
    select('users.id, users.username, COUNT(ads.id) as n_ads')
      .joins(:ads)
      .merge(Ad.give)
      .group('ads.user_owner')
      .unscope(:order)
      .order('n_ads DESC')
      .limit(limit)
  end

  scope :top_last_week, ->(limit = 20) do
    top_overall(limit).where('published_at >= :date', date: 1.week.ago)
  end

  scope :whitelisting, ->(user) do
    joined = joins <<-SQL.squish
      LEFT OUTER JOIN blockings
      ON blockings.blocker_id = users.id AND blockings.blocked_id = #{user.id}
    SQL

    joined.where(blockings: { blocker_id: nil })
  end

  def self.new_with_session(params, session)
    oauth_session = session['devise.omniauth_data']
    return super unless oauth_session

    oauth = OmniAuth::AuthHash.new(oauth_session)

    new do |u|
      u.email = params[:email] || oauth.info.email
      u.username = params[:username] || oauth.info.name
      u.identities.build(provider: oauth.provider, uid: oauth.uid)
      u.confirmed_at = Time.zone.now if oauth.info.email
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

  def mailboxer_email(_object)
    email
  end

  def conversations
    @conversations ||= Conversation.involving(self).order(updated_at: :desc)
  end

  def unread_messages_count
    conversations.unread(self).count
  end

  def mark_as_read(conversation)
    conversation.mark_as_read(self)
  end

  def admin?
    role == 1
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && locked != 1
  end

  def unlock!
    update_column('locked', 0)
  end

  def lock!
    update_column('locked', 1)
  end

  def default_lang
    self.lang ||= 'es'
  end

  def friend?(user)
    friendships.find_by(friend_id: user.id)
  end

  def blocking?(user)
    blockings.find_by(blocked_id: user.id)
  end

  def whitelisting?(user)
    blocking?(user).nil?
  end

  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def valid_password?(password)
    if legacy_password_hash.present?
      if ::Digest::MD5.hexdigest(password).upcase == legacy_password_hash.upcase
        self.password = password
        self.legacy_password_hash = nil
        save!
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
