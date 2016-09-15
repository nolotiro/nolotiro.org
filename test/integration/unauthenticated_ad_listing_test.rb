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
      mocking_all_locations do
        visit root_path

        test.call
      end
    end
  end

  it 'lists first page of available ads everywhere in home page' do
    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_mad'
  end

  it 'lists second page of available ads everywhere in all ads page' do
    click_link 'ver más anuncios'

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava_bar'
  end

  it 'lists booked ads everywhere in all ads page' do
    click_link 'ver más anuncios'
    click_link 'reservado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'res_mad'
  end

  it 'lists delivered ads everywhere in all ads page' do
    click_link 'ver más anuncios'
    click_link 'entregado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'del_ten'
  end

  it 'lists wanted ads when a status filter is active' do
    visit ads_woeid_path(766_273, type: 'give')
    click_link 'disponible'
    click_link 'busco'

    assert_text 'Madrid, Madrid, España'
    assert_selector '.ad_excerpt_list', count: 0
  end

  private

  def mocking_all_locations
    mocking_yahoo_woeid_info(766_273) do
      mocking_yahoo_woeid_info(753_692) do
        mocking_yahoo_woeid_info(773_692) { yield }
      end
    end
  end
end
