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
  end

  def type_string
    I18n.t("nlt.#{type}")
  end

  def status_string
    I18n.t("nlt.#{status}")
  end
end
