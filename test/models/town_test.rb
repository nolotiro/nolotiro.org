# frozen_string_literal: true

require 'test_helper'

class TownTest < ActiveSupport::TestCase
  before do
    @tenerife_spa = create(:town, :tenerife)
    @tenerife_col = create(:town, name: 'Tenerife',
                                  id: 369_486,
                                  _state: :magdalena,
                                  _country: :colombia)
    create(:town, :madrid)
  end

  test '.matching gives matching towns by name' do
    assert_equal 2, Town.matching('tenerife').length
  end

  test '.matching with commas filters regions too' do
    assert_equal 1, Town.matching('tenerife, islas canarias').length
  end

  test '.matching_rank sorts matching towns by number of ads' do
    create(:ad, woeid_code: 369_486)

    rank = Town.matching_rank('tenerife')

    assert_equal 2, rank.length
    assert_equal 'Tenerife, Magdalena, Colombia', rank.first.label
    assert_equal 369_486, rank.first.id
    assert_equal 1, rank.first.n_ads
  end
end
