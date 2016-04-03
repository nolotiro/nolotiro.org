class AnalyticsDestroyUserWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(username)
    category = 'User'
    action = I18n.t('nlt.analytics.user_destroyed')
    label = username

    Analytics.event(category, action, label)
  end
end
