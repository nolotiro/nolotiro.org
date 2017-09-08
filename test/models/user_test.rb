# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @ad = create(:ad)
    @user = create(:user, email: 'jaimito@example.com', username: 'jaimito')
    @admin = create(:admin)
  end

  it 'counts reports recently received' do
    ad = create(:ad, user: @user)
    another_ad = create(:ad, user: @user)
    assert_empty @user.recently_received_reports

    create(:report, ad: ad)
    create(:report, ad: ad, created_at: 2.days.ago)
    assert_equal 1, @user.recently_received_reports.size

    create(:report, ad: another_ad)
    assert_equal 2, @user.recently_received_reports.size
  end

  it 'ignores old reports received' do
    create(:report, ad: create(:ad, user: @user), created_at: 2.days.ago)

    assert_empty @user.recently_received_reports
  end

  it 'aggregates report information from different ads' do
    create(:report, ad: create(:ad, user: @user))
    create(:report, ad: create(:ad, user: @user))

    assert_equal 2, @user.recently_received_reports.size
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
