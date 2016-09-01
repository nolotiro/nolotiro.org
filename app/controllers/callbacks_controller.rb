# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_oauth_callback
  end

  def google_oauth2
    handle_oauth_callback
  end

  private

  def handle_oauth_callback
    if oauth_user.valid?
      sign_in_and_redirect
    else
      session['devise.omniauth_data'] = oauth
      redirect_to new_user_registration_path, alert: flash_message
    end
  end

  def flash_message
    if oauth_user.errors.keys.include?(:email)
      I18n.t('oauth.errors.email_not_provided')
    else
      I18n.t('oauth.errors.duplicated_username', provider: oauth['provider'])
    end
  end

  def sign_in_and_redirect
    oauth_user.save!
    sign_in oauth_user
    redirect_to root_url
  end

  def oauth_user
    @oauth_user ||= OauthenticatorService.new(oauth).authenticate
  end

  def oauth
    request.env['omniauth.auth']
  end
end
