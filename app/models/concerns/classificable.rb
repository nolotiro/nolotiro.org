# frozen_string_literal: true

#
# Types of ads
#
module Classificable
  extend ActiveSupport::Concern

  included do
    enum status: { available: 1, booked: 2, delivered: 3 }

    validates :status, presence: true, if: :give?
    validates :status, absence: true, if: :want?

    enum type: { give: 1, want: 2 }
    validates :type, presence: true

    scope :active, -> { where('published_at >= ?', expiration_limit) }
    scope :expired, -> { where('published_at < ?', expiration_limit) }
    scope :undelivered, -> { where(status: %i[booked available]) }

    scope :currently_available, -> { available.active }
    scope :currently_booked, -> { booked.active }
    scope :currently_delivered, -> { delivered }
    scope :currently_expired, -> { expired.undelivered }
  end

  class_methods do
    def expiration_limit
      1.month.ago
    end
  end

  def type_string
    I18n.t("nlt.#{type}")
  end

  def status_string
    I18n.t("nlt.#{current_status}")
  end

  def current_status
    return 'expired' if expired? && !delivered?

    status
  end

  def currently_available?
    available? && !expired?
  end

  def expired?
    published_at < self.class.expiration_limit && !delivered?
  end
end
