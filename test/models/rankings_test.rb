# frozen_string_literal: true

require 'test_helper'

class RankingsTest < ActiveSupport::TestCase
  setup do
    @user1 = create(:user, id: 1, username: 'user1')
    @user2 = create(:user, id: 2, username: 'user2')
    @user3 = create(:user, id: 3, username: 'user3')

    3.times { create(:ad, :in_mad, user: @user1) }
    2.times { create(:ad, :in_mad, user: @user2) }
  end

  test 'top overall ignores wanted ads from counts and results' do
    create(:ad, :want, user: @user3)
    @user2.ads.last.move!

    assert_equal [[1, 'user1', 3], [2, 'user2', 1]], User.top_overall.ranked
  end

  test 'top overall gives all time top ad publishers' do
    create(:ad, user: @user3)

    assert_equal [[1, 'user1', 3], [2, 'user2', 2], [3, 'user3', 1]],
                 User.top_overall.ranked
  end

  test 'top overall excludes banned users' do
    create(:ad, user: @user3)
    @user1.ban!

    assert_equal [[2, 'user2', 2], [3, 'user3', 1]], User.top_overall.ranked
  end

  test "top last week gives last week's top publishers" do
    create(:ad, user: @user3, published_at: 8.days.ago)

    assert_equal [[1, 'user1', 3], [2, 'user2', 2]], User.top_last_week.ranked
  end

  test 'top last week excludes banned users' do
    create(:ad, user: @user3, published_at: 8.days.ago)
    @user1.ban!

    assert_equal [[2, 'user2', 2]], User.top_last_week.ranked
  end

  test 'top locations returns cities with most ads' do
    assert_equal [[766_273, 'Madrid', 3 + 2]], Ad.top_locations.ranked
  end

  test 'top locations excludes ads by banned users' do
    @user1.ban!

    assert_equal [[766_273, 'Madrid', 2]], Ad.top_locations.ranked
  end

  test 'top overall city with all users ads in the same city' do
    assert_equal [[1, 'user1', 3], [2, 'user2', 2]],
                 User.top_city_overall(766_273).ranked
  end

  test 'top overall city with users ads in different cities' do
    @user2.ads.last.update!(woeid_code: 753_692)

    assert_equal [[1, 'user1', 3], [2, 'user2', 1]],
                 User.top_city_overall(766_273).ranked

    assert_equal [[2, 'user2', 1]], User.top_city_overall(753_692).ranked
  end
end
