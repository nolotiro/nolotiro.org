require 'test_helper'
require 'support/web_mocking'

class WoeidHelperTest < ActionView::TestCase
  include WebMocking

  test "should convert a WOEID to a place name in the given format" do
    mocking_yahoo_woeid_info(455825) do
      location = WoeidHelper.convert_woeid_name(455825)
      assert_equal("Río de Janeiro, Rio de Janeiro, Brasil", location[:full])
      assert_equal("Río de Janeiro", location[:short])
    end
  end

  test "should search serveral cities with the same name" do
    mocking_yahoo_woeid_similar(455825) do
      actual = WoeidHelper.search_by_name("Río de Janeiro") 
      expected = [["Río de Janeiro, Rio de Janeiro, Brasil (0 anuncios)", 455825]]
      assert_equal(expected, actual)
    end
  end

end
