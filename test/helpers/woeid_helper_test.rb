# frozen_string_literal: true

require 'test_helper'

class WoeidHelperTest < ActionView::TestCase
  test 'suggests cities with similar names' do
    create(:town, name: 'Tenerife',
                  id: 369_486,
                  _state: :magdalena,
                  _country: :colombia)

    create(:town, name: 'Tenerife',
                  id: 369_485,
                  _state: :cordoba,
                  _country: :colombia)

    create(:town, :tenerife)
    create(:town, :madrid)

    actual = WoeidHelper.search_by_name('tenerife')
    options = [
      ['Tenerife, Magdalena, Colombia (0 anuncios)', 369_486],
      ['Tenerife, Cordoba, Colombia (0 anuncios)', 369_485],
      ['Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)', 773_692]
    ]

    assert_equal options, actual.as_options
  end
end
