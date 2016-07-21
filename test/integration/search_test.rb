# frozen_string_literal: true
require 'test_helper'
require 'support/sphinx'
require 'support/web_mocking'

class Search < ActionDispatch::IntegrationTest
  include WebMocking
  include SphinxHelpers

  before do
    ThinkingSphinx::Test.start

    create(:ad, woeid_code: 766_273, title: 'muebles oro', status: 1)
    create(:ad, woeid_code: 766_273, title: 'tele', type: 2)
    create(:ad, woeid_code: 753_692, title: 'muebles plata', status: 1)

    index

    mocking_yahoo_woeid_info(766_273) do
      visit ads_woeid_path(766_273, type: 'give')
    end
  end

  after { ThinkingSphinx::Test.stop }

  it 'searchs ads in current location by title' do
    fill_in 'q', with: 'muebles'
    click_button 'buscar'

    page.assert_selector '.ad_excerpt_list', count: 1, text: 'muebles oro'
  end

  it 'shows a no results message when nothing found in current location' do
    fill_in 'q', with: 'espejo'
    click_button 'buscar'

    page.assert_selector '.ad_excerpt_list', count: 0
    assert_content 'No hay anuncios que coincidan con la búsqueda espejo en ' \
                   'la ubicación Madrid, Madrid, España'
  end

  it 'sucessfully changes ad type when searching' do
    fill_in 'q', with: 'tele'
    click_button 'buscar'

    page.assert_selector '.ad_excerpt_list', count: 0
    click_link 'busco'

    page.assert_selector '.ad_excerpt_list', count: 1
  end
end
