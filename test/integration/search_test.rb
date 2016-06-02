require 'test_helper'
require 'support/sphinx'

class Search < ActionDispatch::IntegrationTest
  include SphinxHelpers

  before do
    ThinkingSphinx::Test.start

    create(:ad, woeid_code: 766_273, title: 'muebles', status: 1)
    create(:ad, woeid_code: 766_273, title: 'tele', status: 2)

    index

    visit ads_woeid_path(766_273, type: 'give')
  end

  after { ThinkingSphinx::Test.stop }

  it 'searchs ads by title' do
    fill_in 'q', with: 'muebles'
    click_button 'buscar'

    page.assert_selector '.ad_excerpt_home', count: 1
  end
end
