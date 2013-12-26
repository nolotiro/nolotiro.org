class CommentsMailer < ActionMailer::Base
  default from: APP_CONFIG["default_from_email"]

  def create(ad_id, comment)
    @comment = comment
    @ad = Ad.find ad_id
    mail(
      to: @ad.user.email,
      subject: "[nolotiro.org] Tienes un nuevo comentario en el anuncio #{@ad.title}"
    )
  end

end
