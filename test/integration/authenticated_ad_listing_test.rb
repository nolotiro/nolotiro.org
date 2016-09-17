# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class AuthenticatedAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Warden::Test::Helpers
  include Pagination

  around do |test|
    create(:ad, :in_mad, title: 'ava_mad1', status: 1, published_at: 1.hour.ago)
    create(:ad, :in_bar, title: 'ava_bar', status: 1, published_at: 2.hours.ago)
    create(:ad, :in_mad, title: 'ava_mad2', status: 1, published_at: 1.day.ago)
    create(:ad, :in_mad, title: 'res_mad', status: 2)
    create(:ad, :in_mad, title: 'del_mad', status: 3)

    login_as create(:user, woeid: 766_273)

    with_pagination(1) do
      VCR.use_cassette('mad_bar_ten_info_es') { test.call }
    end

    logout
  end

  it 'shows a link to publish ads in the users location' do
    visit root_path

    assert_selector 'a', text: '+ Publicar anuncio en Madrid'
  end

  it 'lists first page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad1'
  end

  it 'lists other pages of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_bar'
  end

  it 'lists first page of available ads in users location in home page' do
    visit root_path

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad1'
  end

  it 'lists other pages of available ads in users location in home page' do
    visit root_path
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad2'
  end

  it 'lists reserved ads in users location in home page' do
    visit root_path
    click_link 'reservado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'res_mad'
  end

  it 'lists delivered ads in users location in home page' do
    visit root_path
    click_link 'entregado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'del_mad'
  end
end
