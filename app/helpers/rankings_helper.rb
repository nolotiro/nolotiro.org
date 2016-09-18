# frozen_string_literal: true

module RankingsHelper
  def last_week_user_ranking
    return User.top_last_week unless @id

    User.top_city_last_week(@id)
  end

  def overall_user_ranking
    return User.top_overall unless @id

    User.top_city_overall(@id)
  end
end
