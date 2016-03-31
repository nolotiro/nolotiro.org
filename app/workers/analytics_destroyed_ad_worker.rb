class AnalyticsDestroyedAdWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(title)
    category = 'Ad'
    action = I18n.t('nlt.analytics.ad_destroyed')
    label = title

    Analytics.event(category, action, label)
  end
end
