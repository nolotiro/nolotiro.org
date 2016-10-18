# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class AuthenticatedAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Warden::Test::Helpers
  include Pagination
  include Minitest::Hooks

  around do |&block|
    create(:ad, :available, :in_bar, title: 'avabar', published_at: 1.day.ago)
    create(:ad, :available, :in_mad, title: 'avamad1', published_at: 2.days.ago)
    create(:ad, :available, :in_mad, title: 'avamad2', published_at: 3.days.ago)
    create(:ad, :booked, :in_mad, title: 'resmad')
    create(:ad, :delivered, :in_mad, title: 'delmad')
    create(:ad, :want, :in_bar, title: 'busbar')

    login_as create(:user, woeid: 766_273)

    with_pagination(1) do
      VCR.use_cassette('mad_bar_ten_info_es') { super(&block) }
    end

    logout
  end

  it 'shows a link to publish ads in the users location' do
    visit root_path

    assert_selector 'a', text: '+ Publicar anuncio en Madrid'
  end

  it 'lists first page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')

    assert_selector '.ad_excerpt_list', count: 1, text: 'avabar'
  end

  it 'lists other pages of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'avamad1'
  end

  it 'lists first page of available ads in users location in home page' do
    visit root_path

    assert_selector '.ad_excerpt_list', count: 1, text: 'avamad1'
  end

  it 'lists other pages of available ads in users location in home page' do
    visit root_path
    click_link 'siguiente'

    assert_selector '.ad_excerpt_list', count: 1, text: 'avamad2'
  end

  it 'lists petitions in users location in home page' do
    visit root_path
    click_link 'peticiones'

    assert_selector '.ad_excerpt_list', count: 0
  end

  it 'lists available ads in users location in home page' do
    visit root_path
    click_link 'disponible'

    assert_selector '.ad_excerpt_list', count: 1, text: 'avamad1'
  end

  it 'lists reserved ads in users location in home page' do
    visit root_path
    click_link 'reservado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'resmad'
  end

  it 'lists delivered ads in users location in home page' do
    visit root_path
    click_link 'entregado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'delmad'
  end
end
