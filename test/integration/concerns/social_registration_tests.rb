# frozen_string_literal: true

require "support/oauth"
require "support/web_mocking"

module SocialRegistrationTests
  include OauthHelpers
  include WebMocking

  def test_properly_authenticates_user_when_facebook_account_has_an_email
    login_via(@provider, name: "pepe", email: "pepe@example.com")

    assert_link "pepe"
  end

  def test_succesfully_links_to_old_user_if_email_already_present_in_db
    user = create(:user, username: "pepito", email: "pepe@example.com")
    mocking_yahoo_woeid_info(user.woeid) do
      login_via(@provider, name: "pepe", email: "pepe@example.com")
    end

    assert_link "pepito"
  end
end
