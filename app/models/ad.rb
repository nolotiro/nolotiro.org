# encoding : utf-8
# frozen_string_literal: true

class Ad < ActiveRecord::Base
  include Censurable
  censors :title, presence: true, min_length: 4
  censors :body, presence: true, min_length: 25

  include Hidable
  include Spamable
  include Statable

  counter_stats_for :published_at

  belongs_to :user, foreign_key: :user_owner, counter_cache: true
  has_many :comments, foreign_key: :ads_id, dependent: :destroy

  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 1000 }
  validates :user_owner, presence: true
  validates :woeid_code, presence: true

  enum status: { available: 1, booked: 2, delivered: 3 }
  validates :status, presence: true, if: :give?
  validates :status, absence: true, if: :want?

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

  scope :recent, -> { Ad.includes(:user).recent_first.limit(90) }

  scope :by_woeid_code, ->(woeid_code) do
    return all unless woeid_code.present?
    where(woeid_code: woeid_code)
  end

  scope :by_title, ->(query) do
    sanitized_query = query.try(:scrub, '')
    return all unless sanitized_query.present?

    where('title LIKE ?', "%#{sanitized_query}%")
  end

  paginates_per 20

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

  def increment_readed_count!
    Ad.increment_counter(:readed_count, id)
  end

  def move!
    update!(type: give? ? :want : :give, status: give? ? nil : :available)
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
    update!(published_at: Time.zone.now, readed_count: 1)
  end
end
