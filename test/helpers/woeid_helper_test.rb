require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  include WoeidHelper

  test "should convert a WOEID to a place name in the given format" do
    location = WoeidHelper.convert_woeid_name(766273)
    assert_equal(location[:full], "Madrid, Madrid, España")
    assert_equal(location[:short], "Madrid")
  end

  test "should search serveral cities with the same name" do
    results = WoeidHelper.search_by_name("Leganés") 
    expected_results = [["Leganés, Madrid, España (0 anuncios)", 765045], ["Leganés, Bisayas Occidentales, Filipinas (0 anuncios)", 1177959]]
    assert_equal(expected_results, results)
  end

end
