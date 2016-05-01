class AnalyticsDeliveredAdWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(ad_id)
    ad = Ad.find(ad_id)
    category = ad.class.name
    action = I18n.t('nlt.analytics.ad_delivered')
    label = ad.title
    gid = ad.id

    Analytics.event(category, action, label, gid)
  end
end
