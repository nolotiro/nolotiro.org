# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class WoeidHelperTest < ActionView::TestCase
  include WebMocking

  after { Rails.cache.clear }

  test 'converts a WOEID to a place name in the given format' do
    mocking_yahoo_woeid_info(766273) do
      location = WoeidHelper.convert_woeid_name(766273)
      assert_equal('Madrid, Madrid, España', location[:full])
      assert_equal('Madrid', location[:short])
    end
  end

  test 'suggests cities with similar names' do
    mocking_yahoo_woeid_similar('tenerife') do
      actual = WoeidHelper.search_by_name('tenerife')

      names = [
        'Tenerife, Magdalena, Colombia (0 anuncios)',
        'Tenerife, Cordoba, Colombia (0 anuncios)',
        'Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)'
      ]
      assert_equal names, actual.map(&:label)

      assert_equal [369486, 369485, 773692], actual.map(&:woeid)
    end
  end

end
