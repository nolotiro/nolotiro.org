# frozen_string_literal: true

require "active_support/concern"

#
# Funcionality related to model stats
#
module Statable
  extend ActiveSupport::Concern

  included do
    scope :last_day, -> { since(1.day.ago) }
    scope :last_week, -> { since(1.week.ago) }
    scope :last_month, -> { since(1.month.ago) }
    scope :last_year, -> { since(1.year.ago) }

    scope :since, ->(period_ago) do
      where(stats_column.gteq(period_ago)) if stats_column
    end
  end

  class_methods do
    def counter_stats_for(column)
      define_singleton_method(:stats_column) do
        arel_table[column.to_sym]
      end
    end
  end
end
