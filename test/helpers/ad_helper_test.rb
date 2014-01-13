require 'test_helper'

class AdHelperTest < ActionView::TestCase
  include AdHelper

  setup do
    @ad = FactoryGirl.create(:ad)
    Rails.cache.clear
  end

  test "should get user ranking" do
    users = AdHelper.get_users_ranking
    assert_equal(users[0].ads_count, 1)
  end

  test "should get locations ranking" do
    locations = AdHelper.get_locations_ranking
    assert_equal(locations, [[766273, 1]]) 
  end

end
