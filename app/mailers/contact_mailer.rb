class ContactMailer < ActionMailer::Base
  layout "mail"
  default from: Rails.application.secrets.emails["default_from"]

  def contact_form(email, message, request)
    @email = email
    @ip_address = GeoHelper.get_ip_address request 
    @ua = request.user_agent
    @message =  message
    mail(
      from: email,
      to: Rails.application.secrets.emails["contact"],
      subject: "nolotiro.org - contact from #{email}"
    )
  end

end
