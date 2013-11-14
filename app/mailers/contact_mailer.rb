class ContactMailer < ActionMailer::Base
  default from: APP_CONFIG["default_from_email"]

  def contact_form(email, message, request)
    @email = email
    @ip_address = GeoHelper.get_ip_address request 
    @ua = request.user_agent
    @message =  message
    mail(
      from: email,
      to: APP_CONFIG["contact_email1"],
      cc: APP_CONFIG["contact_email2"],
      subject: 'nolotiro.org - contact from #{email}'
    )
  end

end
