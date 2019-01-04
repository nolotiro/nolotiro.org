# frozen_string_literal: true

require "test_helper"

class BanningUsersTest < ActiveSupport::TestCase
  test ".recent_spammers gives users blocked by spam recently" do
    _good_guy = create(:user)
    _old_spammer = create(:user, :old_spammer)
    recent_spammer = create(:user, :recent_spammer)

    assert_equal [recent_spammer], User.recent_spammers
  end

  test "suspicious? flags signin IPs from recent spammers" do
    create(:user, :recent_spammer, last_sign_in_ip: "1.1.1.1")

    assert_equal true, User.suspicious?("1.1.1.1")
    assert_equal false, User.suspicious?("2.2.2.2")
  end

  test "suspicious? flags ad publication IPs from recent spammers" do
    create(:ad, user: create(:user, :recent_spammer), ip: "1.1.1.1")

    assert_equal true, User.suspicious?("1.1.1.1")
    assert_equal false, User.suspicious?("2.2.2.2")
  end

  test "suspicious? flags comment publication IPs from recent spammers" do
    create(:comment, user: create(:user, :recent_spammer), ip: "1.1.1.1")

    assert_equal true, User.suspicious?("1.1.1.1")
    assert_equal false, User.suspicious?("2.2.2.2")
  end
end
