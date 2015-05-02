require 'test_helper'

class AdHelperTest < ActionView::TestCase
  include AdHelper

  setup do
    @ad = FactoryGirl.create(:ad)
    Rails.cache.clear
  end

  test "should get user ranking" do
    users = AdHelper.get_users_ranking
    assert_equal(@ad.user.username, users[0].username)
    assert_equal(1, users[0].ads_count)
  end

  test "should get locations ranking" do
    locations = AdHelper.get_locations_ranking
    assert_equal(locations, [["Madrid, Madrid, España", 766273, 1]]) 
  end

end
