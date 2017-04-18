# frozen_string_literal: true

require 'active_support/concern'

#
# Funcionality related to model stats
#
module Statable
  extend ActiveSupport::Concern

  included do
    scope :last_day, -> { where("#{@stats_column} >= ?", 1.day.ago) }
    scope :last_week, -> { where("#{@stats_column} >= ?", 1.week.ago) }
    scope :last_month, -> { where("#{@stats_column} >= ?", 1.month.ago) }
    scope :last_year, -> { where("#{@stats_column} >= ?", 1.year.ago) }
  end

  class_methods do
    def counter_stats_for(column)
      @stats_column = column
    end
  end
end
