class AnalyticsCreateMessageWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(username)
    category = 'Message'
    action = I18n.t('nlt.analytics.message_sent')
    label = username

    Analytics.event(category, action, label)
  end
end
