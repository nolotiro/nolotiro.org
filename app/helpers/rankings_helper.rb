# frozen_string_literal: true

module RankingsHelper
  def last_week_user_ranking
    return User.top_last_week unless current_woeid

    User.top_city_last_week(current_woeid)
  end

  def overall_user_ranking
    return User.top_overall unless current_woeid

    User.top_city_overall(current_woeid)
  end
end
