# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @ad = create(:ad)
    @user = create(:user, email: 'jaimito@example.com', username: 'jaimito')
    @admin = create(:admin)
  end

  test 'roles work' do
    assert_equal false, @user.admin?
    assert_equal true, @admin.admin?
  end

  test 'banning works' do
    @user.ban!
    assert_equal true, @user.banned?
  end

  test 'unbanning works' do
    @user.ban!
    @user.unban!
    assert_equal false, @user.banned?
  end

  test 'toogling banned flag works' do
    @user.ban!
    @user.moderate!
    assert_equal false, @user.banned?
  end

  test 'requires confirmation for new users' do
    user = create(:non_confirmed_user)
    assert_equal false, user.active_for_authentication?
  end

  test 'associated ads are deleted when user is deleted' do
    create(:ad, user: @user)

    assert_difference(-> { Ad.count }, -1) { @user.destroy }
  end

  test 'associated comments are deleted when user is deleted' do
    create(:comment, user: @user)

    assert_difference(-> { Comment.count }, -1) { @user.destroy }
  end

  test 'associated blockings are deleted when user is deleted' do
    create(:blocking, blocker: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  test 'associated incoming blockings are deleted when user is deleted' do
    create(:blocking, blocked: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  test 'associated friendships are deleted when user is deleted' do
    create(:friendship, user: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end

  test 'associated incoming friendships are deleted when user is deleted' do
    create(:friendship, friend: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end
end
