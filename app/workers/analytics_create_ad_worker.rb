class AnalyticsCreateAdWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(ad_id)
    ad = Ad.find(ad_id)
    category = ad.class.name
    if ad.type == 2
      action = I18n.t('nlt.analytics.want_published')
    else
      action = I18n.t('nlt.analytics.give_published')
    end
    label = ad.title
    gid = ad.id

    Analytics.event(category, action, label, gid)
  end
end
