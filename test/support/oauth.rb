# frozen_string_literal: true

module OauthHelpers
  def login_via(provider, attrs)
    OmniAuth.config.test_mode = true
    mock_oauth(provider, attrs)
    visit public_send(:"user_#{provider}_omniauth_authorize_path")
  end

  private

  def mock_oauth(provider, info)
    OmniAuth.config.mock_auth[provider] =
      OmniAuth::AuthHash.new(provider: provider, uid: '1', info: info)
  end
end
