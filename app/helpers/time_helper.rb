# frozen_string_literal: true

module TimeHelper
  def time_ago_in_words(time)
    content_tag(:time, datetime: time.to_s(:db), title: time.to_s(:db)) do
      t('time_ago_in_words', time: distance_of_time_in_words_to_now(time))
    end
  end

  def published_ago_by(time, user)
    content_tag(:span, class: 'ad_date') do
      t('nlt.published_ago_by_html', time: time_ago_in_words(time), user: user)
    end
  end

  def linked_published_ago_by(time, user)
    username = user.username

    published_ago_by(time, link_to(username, profile_path(username)))
  end
end
