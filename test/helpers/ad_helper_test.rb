require 'test_helper'
require 'support/web_mocking'

class AdHelperTest < ActionView::TestCase
  include WebMocking

  setup { FactoryGirl.create(:ad, woeid_code: 455825) }

  test "should get locations ranking" do
    mocking_yahoo_woeid_info(455825) do
      actual = AdHelper.get_locations_ranking(1)
      expected = [["Río de Janeiro, Rio de Janeiro, Brasil", 455825, 1]]
      assert_equal(expected, actual)
    end
  end

end
