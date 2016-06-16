require 'test_helper'
require 'integration/concerns/authentication'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class AuthenticatedAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Authentication
  include Pagination

  before do
    create(:ad, :in_mad, title: 'ava_mad1', status: 1, published_at: 1.hour.ago)
    create(:ad, :in_bar, title: 'ava_bar', status: 1)
    create(:ad, :in_mad, title: 'ava_mad2', status: 1, published_at: 1.day.ago)
    create(:ad, :in_mad, title: 'res_mad', status: 2)
    create(:ad, :in_mad, title: 'del_mad', status: 3)

    with_pagination(1) do
      login_as create(:user, woeid: 766_273)

      mocking_yahoo_woeid_info(766_273) { visit root_path }
    end
  end

  it 'lists first page of available ads in users location in home page' do
    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_mad1'
  end

  it 'lists other pages of available ads in users location in home page' do
    with_pagination(1) { click_link 'siguiente' }

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_mad2'
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
