# encoding : utf-8
# frozen_string_literal: true
class Ad < ActiveRecord::Base
  include Hidable
  include Rakismet::Model

  # https://github.com/joshfrench/rakismet
  #
  # author        : name submitted with the comment
  # author_url    : URL submitted with the comment
  # author_email  : email submitted with the comment
  # comment_type  : Defaults to comment but you can set it to trackback, pingback, or something more appropriate
  # content       : the content submitted
  # permalink     : the permanent URL for the entry the comment belongs to
  # user_ip       : IP address used to submit this comment
  # user_agent    : user agent string
  # referrer      : referring URL (note the spelling)

  rakismet_attrs  author: proc { user.username },
                  author_email: proc { user.email },
                  user_ip: proc { ip },
                  content: proc { body }

  require 'ipaddress'

  belongs_to :user, foreign_key: :user_owner, counter_cache: true
  has_many :comments, foreign_key: :ads_id, dependent: :destroy

  validates :title, presence: true, length: { minimum: 4, maximum: 100 }
  validates :body, presence: true, length: { minimum: 25, maximum: 1000 }
  validates :user_owner, presence: true
  validates :woeid_code, presence: true
  validates :ip, presence: true

  validates :status,
            inclusion: { in: [1, 2, 3], message: 'no es un estado válido' },
            presence: true

  validates :type,
            inclusion: { in: [1, 2], message: 'no es un tipo válido' },
            presence: true

  # validate :valid_ip_address

  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil

  scope :recent_first, -> { order(published_at: :desc) }

  has_attached_file :image,
                    styles: { thumb: '100x90>' },
                    process_in_background: :image,
                    url: '/system/img/:attachment/:id_partition/:style/:filename'

  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  validates_attachment_size :image, in: 0.megabytes..5.megabytes

  # before_save :titleize_title if self.title? and /[[:upper:]]/.match(self.title)
  # before_save :titleize_body if self.body and /[[:upper:]]/.match(self.body)

  scope :recent, -> { Ad.includes(:user).recent_first.limit(90) }
  scope :last_week, -> { where('published_at >= :date', date: 1.week.ago) }

  scope :give, -> { where(type: 1) }
  scope :want, -> { where(type: 2) }

  scope :by_type, ->(type) do
    return all unless type.present?
    where(type: type)
  end

  scope :available, -> { where(status: 1) }
  scope :booked, -> { where(status: 2) }
  scope :delivered, -> { where(status: 3) }

  scope :by_status, ->(status) do
    return all unless status.present?
    where(status: status)
  end

  scope :by_woeid_code, ->(woeid_code) do
    return all unless woeid_code.present?
    where(woeid_code: woeid_code)
  end

  scope :by_title, ->(query) do
    sanitized_query = query.try(:scrub, '')
    return all unless sanitized_query.present?

    where('title LIKE ?', "%#{sanitized_query}%")
  end

  self.per_page = 20

  scope :top_locations, ->(limit = 20) do
    give.group(:woeid_code).order('count_id desc').limit(limit).count('id')
  end

  def self.cache_digest
    last_ad_publication = Ad.maximum(:published_at)
    return '0' * 20 unless last_ad_publication

    last_ad_publication.strftime('%d%m%y%H%M%s')
  end

  def body
    ApplicationController.helpers.escape_privacy_data(self[:body])
  end

  def title
    ApplicationController.helpers.escape_privacy_data(self[:title])
  end

  def reset_readed_count!
    update_column(:readed_count, 0)
  end

  def increment_readed_count!
    Ad.increment_counter(:readed_count, id)
  end

  def slug
    title.parameterize
  end

  def woeid_name
    woeid[:full]
  end

  def woeid_name_short
    woeid[:short]
  end

  def woeid
    @woeid ||= WoeidHelper.convert_woeid_name(woeid_code)
  end

  def full_title
    type_string + ' segunda mano ' + title + ' ' + woeid_name
  end

  def type_string
    type == 2 ? I18n.t('nlt.want') : I18n.t('nlt.give')
  end

  def type_class
    case type
    when 1
      'give'
    when 2
      'want'
    else
      'give'
    end
  end

  def status_class
    case status
    when 1
      'available'
    when 2
      'booked'
    when 3
      'delivered'
    else
      'available'
    end
  end

  def status_string
    case status
    when 1
      I18n.t('nlt.available')
    when 2
      I18n.t('nlt.booked')
    when 3
      I18n.t('nlt.delivered')
    else
      I18n.t('nlt.available')
    end
  end

  def valid_ip_address
    errors.add(:ip, 'No es una IP válida') unless IPAddress.valid?(ip)
  end

  def give?
    type == 1
  end

  def meta_title
    "#{I18n.t('nlt.keywords')} #{title} #{woeid_name}"
  end

  def bumpable?
    published_at <= 5.days.ago
  end

  def bump
    touch(:published_at)

    reset_readed_count!
  end
end
