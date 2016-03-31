class AnalyticsCreateUserWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(user_id)
    user = User.find(user_id)
    category = user.class.name
    action = I18n.t('nlt.analytics.user_created')
    label = user.username
    gid = user.id

    Analytics.event(category, action, label, gid)
  end
end
