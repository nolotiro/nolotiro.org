require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  include WoeidHelper

  test "should convert a WOEID to a place name in the given format and lang ES" do
    location = WoeidHelper.convert_woeid_name(766273,"ES")
    assert_equal(location[:full], "Madrid, Madrid, España")
    assert_equal(location[:short], "Madrid")
  end

  test "should search serveral cities with the same name and lang ES" do
    results = WoeidHelper.search_by_name("Bilbao", "ES" ) 
    expected_results = [["Bilbao, País Vasco, España (0 anuncios)", 754542], ["Bilbao, Tolima, Colombia (0 anuncios)", 351483], ["Bilbao, Andalucía, España (0 anuncios)", 90231453], ["Bilbao, Bicolandia, Filipinas (0 anuncios)", 1163615]]
    assert_equal(expected_results, results)
  end

end
