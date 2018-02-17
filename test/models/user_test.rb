# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:user, email: "jaimito@example.com", username: "jaimito")
    @admin = create(:admin)
  end

  test "roles work" do
    assert_equal false, @user.admin?
    assert_equal true, @admin.admin?
  end

  test "banning works" do
    @user.ban!
    assert_equal true, @user.banned?
  end

  test "unbanning works" do
    @user.ban!
    @user.unban!
    assert_equal false, @user.banned?
  end

  test "toogling banned flag works" do
    @user.ban!
    @user.moderate!
    assert_equal false, @user.banned?
  end

  it "requires confirmation for new users" do
    user = create(:non_confirmed_user)
    assert_equal false, user.active_for_authentication?
  end

  it "deletes associated ads when user is deleted" do
    create(:ad, user: @user)

    assert_difference(-> { Ad.count }, -1) { @user.destroy }
  end

  it "deletes associated comments when user is deleted" do
    create(:comment, user: @user)

    assert_difference(-> { Comment.count }, -1) { @user.destroy }
  end

  it "deletes associated blockings when user is deleted" do
    create(:blocking, blocker: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  it "deletes associated incoming blockings when user is deleted" do
    create(:blocking, blocked: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  it "deletes associated friendships when user is deleted" do
    create(:friendship, user: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end

  it "deletes associated incoming friendships when user is deleted" do
    create(:friendship, friend: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end

  it "deletes associated reports when user is deleted" do
    create(:report, reporter: @user)

    assert_difference(-> { Report.count }, -1) { @user.destroy }
  end

  it "deletes associated incoming reports when user is deleted" do
    create(:report, reported: @user)

    assert_difference(-> { Report.count }, -1) { @user.destroy }
  end
end
