# frozen_string_literal: true

#
# User rankings
#
module Rankable
  extend ActiveSupport::Concern

  included do
    scope :top_overall, -> { build_rank(Ad, "top-overall") }
    scope :top_last_week, -> { build_rank(Ad.last_week, "top-last-week") }

    scope :top_city_overall, ->(woeid) do
      build_rank(Ad.by_woeid_code(woeid), "woeid/#{woeid}/top-overall")
    end

    scope :top_city_last_week, ->(woeid) do
      build_rank(Ad.last_week.by_woeid_code(woeid),
                 "woeid/#{woeid}/top-last-week")
    end
  end

  class_methods do
    def build_rank(ads_scope, name)
      AdRanking.new(ads_scope.give.joins(:user).merge(legitimate),
                    name: name,
                    metric: :user_owner,
                    select_extras: [:username])
    end
  end
end
