require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  include WoeidHelper

  test "should convert a WOEID to a place name in the given format" do
    location = WoeidHelper.convert_woeid_name 766273
    assert_equal(location[:full], "Madrid, Madrid, España")
    assert_equal(location[:short], "Madrid")
  end

  test "should search serveral cities with the same name" do
    results = WoeidHelper.search_by_name "Bilbao" 
    expected_results = [["Bilbao, País Vasco, España (0 anuncios)", 754542], ["Bilbao, Tolima, Colombia (0 anuncios)", 351483], ["Bilbao, Chimborazo, Ecuador (0 anuncios)", 56189784], ["Bilbao, Andalucía, España (0 anuncios)", 90231453], ["Bilbao (hda de Las Torres Univ), Chihuahua, México (0 anuncios)", 55885079], ["Bilbao, Bicolandia, Filipinas (0 anuncios)", 1163615], ["Bilbao, País Vasco, España (0 anuncios)", 90251343], ["Bilbao, Santiago del Estero, Argentina (0 anuncios)", 91831128]]
    assert_equal(expected_results, results)
  end

end
