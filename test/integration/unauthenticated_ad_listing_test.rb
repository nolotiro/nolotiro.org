# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class UnauthenticatedAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Pagination
  include Minitest::Hooks

  around do |&block|
    create(:ad, :available, :in_mad, title: 'avamad', published_at: 1.day.ago)
    create(:ad, :available, :in_bar, title: 'avabar', published_at: 2.days.ago)
    create(:ad, :available, :in_bar, :expired, title: 'avabar2')
    create(:ad, :booked, :in_mad, title: 'resmad')
    create(:ad, :booked, :in_mad, :expired, title: 'resmad2')
    create(:ad, :delivered, :in_ten, title: 'delten')
    create(:ad, :delivered, :in_ten, :expired, title: 'delten2')
    create(:ad, :want, :in_mad, title: 'wantmad')

    with_pagination(1) do
      VCR.use_cassette('mad_bar_ten_info_es', record: :new_episodes) do
        super(&block)
      end
    end
  end

  it 'lists first page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')

    assert_selector '.ad_excerpt', count: 1, text: 'avamad'
  end

  it 'lists second page of available ads everywhere in all ads page' do
    visit ads_listall_path(type: 'give')
    click_link 'siguiente'

    assert_selector '.ad_excerpt', count: 1, text: 'avabar'
  end

  it 'lists first page of available ads everywhere in home page' do
    visit root_path

    assert_selector '.ad_excerpt', count: 1, text: 'avamad'
  end

  it 'lists second page of available ads everywhere in home page' do
    visit root_path
    click_link 'siguiente'

    assert_selector '.ad_excerpt', count: 1, text: 'avabar'
    assert_no_link 'siguiente'
  end

  it 'lists booked ads everywhere in home page' do
    visit root_path
    click_link 'siguiente'
    click_link 'reservado'

    assert_selector '.ad_excerpt', count: 1, text: 'resmad'
    assert_no_link 'siguiente'
  end

  it 'lists delivered ads everywhere including expired ones in home page' do
    visit root_path
    click_link 'siguiente'
    click_link 'entregado'

    assert_selector '.ad_excerpt', count: 1, text: 'delten'

    click_link 'siguiente'

    assert_selector '.ad_excerpt', count: 1, text: 'delten2'
  end

  it 'lists petitions everywhere in home page' do
    visit root_path
    click_link 'peticiones'

    assert_text 'Madrid, Madrid, España'
    assert_selector '.ad_excerpt', count: 1, text: 'wantmad'
  end
end
