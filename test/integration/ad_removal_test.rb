# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'

class AdRemovalTest < AuthenticatedTest
  before { @ad = create(:ad, user: @current_user) }

  it 'properly deletes ads' do
    visit ads_edit_path(@ad)
    assert_difference('Ad.count', -1) { click_link 'Borrar anuncio' }

    assert_text 'Hemos borrado el anuncio'
    assert_equal listads_user_path(@current_user), current_path
  end
end
