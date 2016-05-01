class AnalyticsCreateCommentWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'analytics_worker'

  def perform(comment_id)
    comment = Comment.find(comment_id)
    category = comment.class.name
    action = I18n.t('nlt.analytics.comment_created')
    label = comment.ad.title
    gid = comment.id

    Analytics.event(category, action, label, gid)
  end
end
