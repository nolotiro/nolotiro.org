# frozen_string_literal: true

class Ad < ApplicationRecord
  include Censurable
  censors :title
  censors :body

  include Classificable
  include Hidable
  include Spamable
  include Statable

  counter_stats_for :published_at

  belongs_to :town, foreign_key: :woeid_code
  validates :town, presence: true

  belongs_to :user, foreign_key: :user_owner, counter_cache: true
  validates :user, presence: true

  has_many :comments, foreign_key: :ads_id, dependent: :destroy, inverse_of: :ad

  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 1000 }

  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil

  scope :recent_first, -> { order(published_at: :desc) }

  has_attached_file :image,
                    styles: { thumb: "160x160>", original: "800x800>" },
                    url: "/system/img/:attachment/:id_partition/:style/:filename",
                    default_url: "/images/:style_missing.png"

  validates_attachment :image,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_attachment_size :image, in: 0.megabytes..5.megabytes

  scope :latest, ->(limit) { recent_first.limit(limit) }

  scope :by_woeid_code, ->(woeid_code) do
    return all if woeid_code.blank?
    where(woeid_code: woeid_code)
  end

  scope :by_title, ->(query) do
    sanitized_query = query.try(:scrub, "")
    return all if sanitized_query.blank?

    where("title LIKE ?", "%#{sanitized_query}%")
  end

  paginates_per 20

  scope :top_locations, -> do
    AdRanking.new(Ad.give.from_legitimate_authors.joins(:town),
                  name: 'top-locations',
                  metric: :woeid_code,
                  extra: ['towns.name'])
  end

  def increment_readed_count!
    increment!(:readed_count) # rubocop:disable Rails/SkipsModelValidations
  end

  def move!
    update!(type: give? ? :want : :give, status: give? ? nil : :available)
  end

  def slug
    filtered_title.parameterize
  end

  def woeid_name
    town.fullname
  end

  def woeid_name_short
    town.name
  end

  def meta_title
    "#{type_string} - #{title} - #{woeid_name}"
  end

  def bumpable?
    published_at <= 5.days.ago && !delivered?
  end

  def bump
    attributes = { published_at: Time.zone.now, readed_count: 1 }
    attributes[:status] = :available if give?

    update!(attributes)
    comments.destroy_all
  end
end
