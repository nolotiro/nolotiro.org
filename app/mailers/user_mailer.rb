class UserMailer < ActionMailer::Base
  layout "mail"

  def confirmation_reminder(resource)
    @resource = resource
    mail(
      to: @resource.email,
      subject: "[nolotiro.org] Falta que confirmes tu cuenta"
    )
  end

end
