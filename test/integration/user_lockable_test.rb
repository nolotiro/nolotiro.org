require "test_helper"
require "integration/concerns/authentication"

class UserLockable < ActionDispatch::IntegrationTest
  include Authentication

  it "should lock after 10 tries on user" do
    @user = FactoryGirl.create(:user)

    (1..8).each do |n|
      login(@user.email, "trololololo")
      page.must_have_content I18n.t('devise.failure.not_found_in_database')
    end

    login(@user.email, "trololololo")
    page.must_have_content I18n.t('devise.failure.last_attempt')

    login(@user.email, "trololololo")
    page.must_have_content I18n.t('devise.failure.locked')
  end
end
