class ContactController < ApplicationController

  # GET /contact
  def new
    @contact = Contact.new
  end

  # POST /contact
  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid? and verify_recaptcha(:model => @contact, :message => t('nlt.captcha_error'))
      ContactMailer.contact_form(@contact.email, @contact.message, request).deliver
      redirect_to root_url, notice: t('nlt.contact_thanks')
    else
      render "new"
    end
  end

end
