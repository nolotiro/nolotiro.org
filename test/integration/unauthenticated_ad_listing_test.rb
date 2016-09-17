# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class UnauthenticatedAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Pagination

  around do |test|
    create(:ad, :in_mad, title: 'ava_mad', published_at: 1.hour.ago, status: 1)
    create(:ad, :in_bar, title: 'ava_bar', published_at: 2.hours.ago, status: 1)
    create(:ad, :in_mad, title: 'res_mad', status: 2)
    create(:ad, :in_ten, title: 'del_ten', status: 3)

    with_pagination(1) do
      VCR.use_cassette('mad_bar_ten_info_es') { test.call }
    end
  end

  it 'shows a link to show ads in the guessed location' do
    get root_path, {}, 'REMOTE_ADDR' => '74.125.225.224'

    assert_select 'a', 'Ver anuncios en Mountain View'
  end

  it 'lists first page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad'
  end

  it 'lists second page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_bar'
  end

  it 'lists first page of available ads everywhere in home page' do
    visit root_path

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad'
  end

  it 'lists second page of available ads everywhere in home page' do
    visit root_path
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_bar'
  end

  it 'lists booked ads everywhere in home page' do
    visit root_path
    click_link 'siguiente'
    click_link 'reservado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'res_mad'
  end

  it 'lists delivered ads everywhere in home page' do
    visit root_path
    click_link 'siguiente'
    click_link 'entregado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'del_ten'
  end

  it 'lists wanted ads when a status filter is active' do
    visit ads_woeid_path(766_273, type: 'give')
    click_link 'disponible'
    click_link 'peticiones'

    assert_text 'Madrid, Madrid, España'
    assert_selector '.ad_excerpt_list', count: 0
  end
end
