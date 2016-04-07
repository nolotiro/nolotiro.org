require 'test_helper'
require 'integration/concerns/pagination'

class UnauthenticatedAdListing < ActionDispatch::IntegrationTest
  include Pagination

  before do
    create(:ad, title: 'ava_mad',
                published_at: 1.hour.ago,
                woeid_code: 766_273,
                status: 1)

    create(:ad, title: 'ava_bar',
                published_at: 2.hour.ago,
                woeid_code: 753_692,
                status: 1)

    create(:ad, title: 'res_mad', woeid_code: 766_273, status: 2)
    create(:ad, title: 'del_ten', woeid_code: 773_692, status: 3)

    with_pagination(1) { visit root_path }
  end

  it 'lists first page of available ads everywhere in home page' do
    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_mad'
  end

  it 'lists second page of available ads everywhere in all ads page' do
    with_pagination(1) { click_link 'ver más anuncios' }

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_bar'
  end

  it 'lists booked ads everywhere in all ads page' do
    click_link 'ver más anuncios'
    click_link 'reservado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'res_mad'
  end

  it 'lists booked ads everywhere in all ads page' do
    click_link 'ver más anuncios'
    click_link 'entregado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'del_ten'
  end
end
