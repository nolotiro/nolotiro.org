# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @ad = create(:ad)
    @user = create(:user, email: 'jaimito@example.com', username: 'jaimito')
    @admin = create(:admin)
  end

  it 'roles work' do
    assert_equal false, @user.admin?
    assert_equal true, @admin.admin?
  end

  it 'banning works' do
    @user.ban!
    assert_equal true, @user.banned?
  end

  it 'unbanning works' do
    @user.ban!
    @user.unban!
    assert_equal false, @user.banned?
  end

  it 'toogling banned flag works' do
    @user.ban!
    @user.moderate!
    assert_equal false, @user.banned?
  end

  it 'requires confirmation for new users' do
    user = create(:non_confirmed_user)
    assert_equal false, user.active_for_authentication?
  end

  it 'deletest associated ads when user is deleted' do
    create(:ad, user: @user)

    assert_difference(-> { Ad.count }, -1) { @user.destroy }
  end

  it 'deletes associated comments when user is deleted' do
    create(:comment, user: @user)

    assert_difference(-> { Comment.count }, -1) { @user.destroy }
  end

  it 'deletes associated blockings when user is deleted' do
    create(:blocking, blocker: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  it 'deletest associated incoming blockings when user is deleted' do
    create(:blocking, blocked: @user)

    assert_difference(-> { Blocking.count }, -1) { @user.destroy }
  end

  it 'deletes associated friendships when user is deleted' do
    create(:friendship, user: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end

  it 'deletes associated incoming friendships when user is deleted' do
    create(:friendship, friend: @user)

    assert_difference(-> { Friendship.count }, -1) { @user.destroy }
  end
end
