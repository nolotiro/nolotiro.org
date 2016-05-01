class AnalyticsFirstCityAdWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(ad_id)
    ad = Ad.find(ad_id)
    category = 'City'
    action = I18n.t('nlt.analytics.ad_new_city')
    label = WoeidHelper.convert_woeid_name(ad.woeid_code)[:short]

    Analytics.event(category, action, label)
  end
end
