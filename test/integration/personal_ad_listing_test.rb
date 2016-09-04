# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/pagination'
require 'support/web_mocking'

class PersonalAdListing < ActionDispatch::IntegrationTest
  include WebMocking
  include Pagination

  before do
    @user = create(:user)

    create(:ad, :available, user: @user, title: 'ava1', published_at: 1.hour.ago)
    create(:ad, :available, user: @user, title: 'ava2', published_at: 1.day.ago)
    create(:ad, :booked, user: @user, title: 'res1')
    create(:ad, :delivered, user: @user, title: 'del1')
    create(:ad, :want, user: @user, title: 'wan1')

    create(:ad, title: "something else to ensure it's filtered out")

    mocking_yahoo_woeid_info(@user.woeid) { visit listads_user_path(@user) }
  end

  it 'lists all ads in a separate tab in user profile' do
    click_link 'todos'

    assert_selector '.ad_excerpt_list', count: 5
  end

  it 'lists wanted ads in a separate tab in user profile' do
    click_link 'peticiones'

    assert_selector '.ad_excerpt_list', count: 1, text: 'wan1'
  end

  it 'lists first page of user available ads in user profile' do
    with_pagination(1) { click_link 'disponible' }

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava1'
  end

  it 'lists other pages of user available ads in user profile' do
    with_pagination(1) do
      click_link 'disponible'
      click_link 'siguiente'
    end

    assert_selector '.ad_excerpt_list', count: 1, text: 'ava2'
  end

  it 'lists user reserved ads in users profile' do
    click_link 'reservado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'res1'
  end

  it 'lists user delivered ads in users profile' do
    click_link 'entregado'

    assert_selector '.ad_excerpt_list', count: 1, text: 'del1'
  end
end
