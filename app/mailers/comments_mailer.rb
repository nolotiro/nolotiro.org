class CommentsMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails["default_from"]

  def create(ad_id, comment)
    @comment = comment
    @ad = Ad.find ad_id
    mail(
      to: @ad.user.email,
      subject: t('nlt.comments.subject', ad: @ad.title)
    )
  end

end
