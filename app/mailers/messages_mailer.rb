class MessagesMailer < ActionMailer::Base
  layout "mail"
  default from: APP_CONFIG["default_from_email"]

  def create(to_email, from_username, subject, message)
    @subject = subject
    @message = message
    mail(
      to: to_email,
      subject: "[nolotiro.org] Tienes un nuevo mensaje del usuario #{from_username}"
    )
  end

end
