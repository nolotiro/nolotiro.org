# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class Search < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    create(:ad, :available, woeid_code: 766_273, title: 'muebles oro')
    create(:ad, :want, woeid_code: 766_273, title: 'tele')
    create(:ad, :available, woeid_code: 753_692, title: 'muebles plata')

    mocking_yahoo_woeid_info(766_273) do
      visit ads_woeid_path(766_273, type: 'give')
    end
  end

  it 'searchs ads in current location by title' do
    fill_in 'q', with: 'muebles'
    click_button 'buscar'

    assert_selector '.ad_excerpt_list', count: 1, text: 'muebles oro'
  end

  it 'shows a no results message when nothing found in current location' do
    fill_in 'q', with: 'espejo'
    click_button 'buscar'

    assert_selector '.ad_excerpt_list', count: 0
    assert_text 'No hay anuncios que coincidan con la búsqueda espejo'
  end
end
