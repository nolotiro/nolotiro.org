require 'test_helper'
require 'integration/concerns/authentication'
require 'integration/concerns/pagination'

class AuthenticatedAdListing < ActionDispatch::IntegrationTest
  include Authentication
  include Pagination

  before do
    create(:ad, title: 'ava_mad_1', woeid_code: 766_273, status: 1)
    create(:ad, title: 'ava_bar', woeid_code: 753_692, status: 1)
    create(:ad, title: 'ava_mad_2', woeid_code: 766_273, status: 1)
    create(:ad, title: 'res_mad', woeid_code: 766_273, status: 2)
    create(:ad, title: 'del_mad', woeid_code: 766_273, status: 3)

    with_pagination(1) do
      login_as create(:user, woeid: 766_273)
      visit root_path
    end
  end

  it 'lists first page of available ads in users location in home page' do
    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_mad_1'
  end

  it 'lists other pages of available ads in users location in home page' do
    with_pagination(1) { click_link 'siguiente' }

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_mad_2'
  end

  it 'lists reserved ads in users location in home page' do
    click_link 'reservado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'res_mad'
  end

  it 'lists delivered ads in users location in home page' do
    click_link 'entregado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'del_mad'
  end
end
