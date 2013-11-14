class ContactController < ApplicationController

  # GET /contact
  def new
    @contact = Contact.new
  end

  # POST /contact
  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid? and verify_recaptcha(:model => @contact, :message => "Oh! It's error with reCAPTCHA!")
      # TODO send contact here
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end
