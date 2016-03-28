require 'test_helper'

class AdHelperTest < ActionView::TestCase
  include AdHelper

  setup do
    FactoryGirl.create(:ad)
    Rails.cache.clear
  end

  test "should get locations ranking" do
    locations = AdHelper.get_locations_ranking(1)
    assert_equal(locations, [["Madrid, Madrid, España", 766273, 1]]) 
  end

end
