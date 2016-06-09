require 'test_helper'

class AdHelperTest < ActionView::TestCase
  include AdHelper

  setup { FactoryGirl.create(:ad, woeid_code: 455825) }

  test "should get locations ranking" do
    actual = AdHelper.get_locations_ranking(1)
    expected = [["Río de Janeiro, Rio de Janeiro, Brasil", 455825, 1]]
    assert_equal(expected, actual)
  end

end
