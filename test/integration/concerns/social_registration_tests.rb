# frozen_string_literal: true

require 'support/oauth'

module SocialRegistrationTests
  include OauthHelpers

  def test_properly_authenticates_user_when_facebook_account_has_an_email
    login_via(@provider, name: 'pepe', email: 'pepe@example.com')

    assert_text 'hola, pepe'
  end

  def test_succesfully_links_to_old_user_if_email_already_present_in_db
    create(:user, username: 'pepito', email: 'pepe@example.com')
    login_via(@provider, name: 'pepe', email: 'pepe@example.com')

    assert_text 'hola, pepito'
  end
end
