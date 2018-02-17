# frozen_string_literal: true

require "test_helper"
require "support/web_mocking"

class WoeidHelperTest < ActionView::TestCase
  include WebMocking

  after { Rails.cache.clear }

  it "converts a WOEID to a place name in the given format" do
    mocking_yahoo_woeid_info(766_273) do
      location = WoeidHelper.convert_woeid_name(766_273)
      assert_equal("Madrid, Madrid, España", location[:full])
      assert_equal("Madrid", location[:short])
    end
  end

  it "suggests cities with similar names" do
    mocking_yahoo_woeid_similar("tenerife") do
      actual = WoeidHelper.search_by_name("tenerife")
      options = [
        ["Tenerife, Magdalena, Colombia (0 anuncios)", 369_486],
        ["Tenerife, Cordoba, Colombia (0 anuncios)", 369_485],
        ["Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)", 773_692]
      ]

      assert_equal options, actual.as_options
    end
  end
end
