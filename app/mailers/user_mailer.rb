class UserMailer < ActionMailer::Base
  default from: APP_CONFIG["default_from_email"]

  def confirmation_reminder(resource)
    @resource = resource
    mail(
      to: @resource.email,
      subject: "[nolotiro.org] Falta que confirmes tu cuenta"
    )
  end

end
