require 'test_helper'
require 'support/web_mocking'

class WoeidHelperTest < ActionView::TestCase
  include WebMocking

  test "converts a WOEID to a place name in the given format" do
    mocking_yahoo_woeid_info(766273) do
      location = WoeidHelper.convert_woeid_name(766273)
      assert_equal("Madrid, Madrid, España", location[:full])
      assert_equal("Madrid", location[:short])
    end
  end

  test "suggests cities with similar names" do
    mocking_yahoo_woeid_similar("tenerife") do
      actual = WoeidHelper.search_by_name("tenerife") 
      expected = [
        ["Tenerife, Magdalena, Colombia (0 anuncios)", 369486],
        ["Tenerife, Cordoba, Colombia (0 anuncios)", 369485],
        ["Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)", 773692]
      ]
      assert_equal(expected, actual)
    end
  end

end
