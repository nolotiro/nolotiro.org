# frozen_string_literal: true

#
# Funcionality related to model stats
#
module Statable
  def self.included(base)
    base.extend ClassMethods

    base.class_eval do
      scope :last_day, -> { where("#{@stats_column} >= ?", 1.day.ago) }
      scope :last_week, -> { where("#{@stats_column} >= ?", 1.week.ago) }
      scope :last_month, -> { where("#{@stats_column} >= ?", 1.month.ago) }
      scope :last_year, -> { where("#{@stats_column} >= ?", 1.year.ago) }
    end
  end

  module ClassMethods
    def counter_stats_for(column)
      @stats_column = column
    end
  end
end
