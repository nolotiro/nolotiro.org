# encoding : utf-8
# frozen_string_literal: true

class Ad < ActiveRecord::Base
  include Hidable
  include Spamable

  belongs_to :user, foreign_key: :user_owner, counter_cache: true
  has_many :comments, foreign_key: :ads_id, dependent: :destroy

  validates :title, presence: true, length: { minimum: 4, maximum: 100 }
  validates :body, presence: true, length: { minimum: 25, maximum: 1000 }
  validates :user_owner, presence: true
  validates :woeid_code, presence: true

  enum status: { available: 1, booked: 2, delivered: 3 }
  validates :status, presence: true

  enum type: { give: 1, want: 2 }
  validates :type, presence: true

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

  scope :top_locations, -> do
    key = "#{I18n.locale}/top-locations-#{cache_digest}"
    sql_count = 'COUNT(woeid_code) as n_ads'

    Rails.cache.fetch(key) { rank_by(:woeid_code).select(:woeid_code, sql_count) }
  end

  def self.rank_by(*attributes)
    give.group(*attributes).order('n_ads DESC').limit(ranking_size)
  end

  def self.full_ranking?(rank_scope)
    rank_scope.length == ranking_size
  end

  def self.ranking_size
    20
  end

  def self.cache_digest
    last_ad_publication = Ad.maximum(:published_at)
    return '0' * 20 unless last_ad_publication

    last_ad_publication.strftime('%d%m%y%H%M%s')
  end

  def filtered_body
    ApplicationController.helpers.escape_privacy_data(body)
  end

  def filtered_title
    ApplicationController.helpers.escape_privacy_data(title)
  end

  def reset_readed_count!
    update_column(:readed_count, 1)
  end

  def increment_readed_count!
    Ad.increment_counter(:readed_count, id)
  end

  def move!
    update!(type: give? ? :want : :give)
  end

  def slug
    filtered_title.parameterize
  end

  def woeid_name
    woeid_info[:full]
  end

  def woeid_name_short
    woeid_info[:short]
  end

  def woeid_info
    @woeid_info ||= WoeidHelper.convert_woeid_name(woeid_code)
  end

  def type_string
    I18n.t("nlt.#{type}")
  end

  def status_string
    I18n.t("nlt.#{status}")
  end

  def meta_title
    "#{type_string} - #{title} - #{woeid_name}"
  end

  def bumpable?
    published_at <= 5.days.ago
  end

  def bump
    touch(:published_at)

    reset_readed_count!
  end
end
