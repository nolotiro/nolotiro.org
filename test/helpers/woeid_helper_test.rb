require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  include WoeidHelper

  test "should convert a WOEID to a place name in the given format" do
    location = WoeidHelper.convert_woeid_name 766273
    assert_equal(location, "Madrid, Madrid, España")
  end

  test "should search serveral cities with the same name" do
    results = WoeidHelper.search_by_name "Bilbao" 
    expected_results = [["Bilbao, País Vasco, España", 754542], ["Bilbao, Tolima, Colombia", 351483], ["Bilbao, Chimborazo, Ecuador", 56189784], ["Bilbao, Andalucía, España", 90231453], ["Bilbao (hda de Las Torres Univ), Chihuahua, México", 55885079], ["Bilbao, Bicolandia, Filipinas", 1163615], ["Bilbao, País Vasco, España", 90251343], ["Bilbao, Santiago del Estero, Argentina", 91831128]]
    assert_equal(expected_results, results)
  end

end
