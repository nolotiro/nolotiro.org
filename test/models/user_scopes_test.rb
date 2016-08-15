# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class UserScopesTest < ActiveSupport::TestCase
  include WebMocking

  setup do
    Rails.cache.clear

    3.times { create(:ad, user: user1) }
    2.times { create(:ad, user: user2) }
  end

  test 'top overall ignores wanted ads from counts and results' do
    create(:ad, user: user3, type: 2)
    user2.ads.last.update(type: 2)

    results = User.top_overall

    assert_equal 2, results.length
    assert_count results.first, user1.id, user1.username, 3
    assert_count results.second, user2.id, user2.username, 1
  end

  test 'top overall gives all time top ad publishers' do
    create(:ad, user: user3)

    results = User.top_overall

    assert_equal 3, results.length
    assert_count results.first, user1.id, user1.username, 3
    assert_count results.second, user2.id, user2.username, 2
    assert_count results.third, user3.id, user3.username, 1
  end

  test "top last week gives last week's top publishers" do
    create(:ad, user: user3, published_at: 8.days.ago)

    results = User.top_last_week

    assert_equal 2, results.length
    assert_count results.first, user1.id, user1.username, 3
    assert_count results.second, user2.id, user2.username, 2
  end

  test 'top last week accepts argument with number of publishers requested' do
    results = User.top_last_week(1)

    assert_equal 1, results.length
    assert_count results.first, user1.id, user1.username, 3
  end

  test 'top locations returns cities with most ads' do
    mocking_yahoo_woeid_info(766_273) do
      results = Ad.top_locations

      assert_equal 1, results.length
      assert_equal 766_273, results.first.woeid_code
      assert_equal 'Madrid', results.first.woeid_name_short
      assert_equal 3 + 2, results.first.n_ads
    end
  end

  private

  def assert_count(user, id, username, n_ads)
    assert_equal id, user.id
    assert_equal username, user.username
    assert_equal n_ads, user.n_ads
  end

  def user1
    @user1 ||= create(:user, username: 'user1')
  end

  def user2
    @user2 ||= create(:user, username: 'user2')
  end

  def user3
    @user3 ||= create(:user, username: 'user3')
  end
end
