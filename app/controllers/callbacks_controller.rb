class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in user
    redirect_to root_url
  end

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in user
    redirect_to root_url
  end

end
