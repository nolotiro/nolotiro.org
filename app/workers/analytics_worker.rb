class AnalyticsWorker

  include Sidekiq::Worker

  def perform(object_id, nlt_action, options={})
    if Rails.env.development?

      case nlt_action

      when 'create_ad'
        ad = Ad.find(object_id)
        category = ad.class.name
        if ad.type == 2
          action = I18n.t('nlt.analytics.want_published')
        else
          action = I18n.t('nlt.analytics.give_published')
        end
        label = ad.title
        gid = ad.id

        send_to_google(category, action, label, gid)

        # Si es el primer regalo en una ciudad
        if Ad.where(woeid_code: ad.woeid_code).count == 1
          category = 'City'
          action = I18n.t('nlt.analytics.ad_new_city')
          label = WoeidHelper.convert_woeid_name(ad.woeid_code)[:short]

          send_to_google(category, action, label)
        end

      when 'update_ad'
        ad = Ad.find(object_id)
        category = ad.class.name
        action = I18n.t('nlt.analytics.ad_delivered')
        label = ad.title
        gid = ad.id

        send_to_google(category, action, label, gid)

      when 'destroy_ad'
        category = 'Ad'
        action = I18n.t('nlt.analytics.ad_destroyed')
        label = options['title']

        send_to_google(category, action, label)

      when 'user_created'
        user = User.find(object_id)
        category = user.class.name
        action = I18n.t('nlt.analytics.user_created')
        label = user.username
        gid = user.id

        send_to_google(category, action, label, gid)

      when 'user_destroyed'
        category = 'User'
        action = I18n.t('nlt.analytics.user_destroyed')
        label = options['username']

        send_to_google(category, action, label)

      when 'comment_created'
        comment = Comment.find(object_id)
        category = comment.class.name
        action = I18n.t('nlt.analytics.comment_created')
        label = comment.ad.title
        gid = comment.id

        send_to_google(category, action, label, gid)

      when 'message_created'
        category = 'Message'
        action = I18n.t('nlt.analytics.message_sent')
        label = options['username']

        send_to_google(category, action, label)
      end

    else
      # El worker No se ejecuta en desarrollo
      true
    end
  end

  protected

  def send_to_google(category, action, label, gid=nil)
    my_analytics_id = Rails.application.secrets["google_analytics_id"]
    Gabba::Gabba.new(my_analytics_id, "nolotiro.org")
        .event(category, action, label, gid, true)
  end
end
