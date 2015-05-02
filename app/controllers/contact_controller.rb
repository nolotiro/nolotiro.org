class ContactController < ApplicationController
  # TODO: create model for Contact
  # TODO: deliver_later

  # GET /contact
  def new
    @contact = Contact.new
  end

  # POST /contact
  def create
    @contact = Contact.new(params[:contact])
    @contact.email = current_user.email if user_signed_in?
    if @contact.valid? and verify_recaptcha(:model => @contact, :message => t('nlt.captcha_error'))
      ContactMailer.contact_form(@contact.email, @contact.message, request).deliver_now
      redirect_to root_url, notice: t('nlt.contact_thanks')
    else
      render "new"
    end
  end

end
