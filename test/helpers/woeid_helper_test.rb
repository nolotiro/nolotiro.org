require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  include WoeidHelper

  test "should convert a WOEID to a place name in the given format" do
    location = WoeidHelper.convert_woeid_name(455825)
    assert_equal("Río de Janeiro, Rio de Janeiro, Brasil", location[:full])
    assert_equal("Río de Janeiro", location[:short])
  end

  test "should search serveral cities with the same name" do
    results = WoeidHelper.search_by_name("Río de Janeiro") 
    expected_results = [["Río de Janeiro, Rio de Janeiro, Brasil (0 anuncios)", 455825]]
    assert_equal(expected_results, results)
  end

end
