class AnalyticsCreateMessageWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(message_id)
    message = Message.find(message_id)
    username = User.find(message.sender_id).username

    category = message.class.name
    action = I18n.t('nlt.analytics.message_sent')
    label = username

    Analytics.event(category, action, label)
  end
end
