# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/login_helper'

class UserLockable < ActionDispatch::IntegrationTest
  include LoginHelper

  it 'should lock after 10 tries on user' do
    @user = create(:user)

    8.times do
      login(@user.email, 'trololololo')
      assert_text I18n.t('devise.failure.not_found_in_database')
    end

    login(@user.email, 'trololololo')
    assert_text I18n.t('devise.failure.last_attempt')

    login(@user.email, 'trololololo')
    assert_text I18n.t('devise.failure.locked')
  end
end
