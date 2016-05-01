module Analytics
  ANALYTICS_ID = Rails.application.secrets["google_analytics_id"]

  def Analytics.event(category, action, label, gid=nil)
    Gabba::Gabba.new(ANALYTICS_ID, Rails.application.secrets["app_host"])
        .event(category, action, label, gid, true)
  end
end
