# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class UserBlockingsTest < ActionDispatch::IntegrationTest
  include Authentication
  include WebMocking

  before do
    @current_user = create(:user)
    @other = create(:user, username: 'other')

    login_as @current_user
  end

  it 'does not show profile page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) { visit profile_path(@other) }

    assert_text 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show listads page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit listads_user_path(@other)
    end

    assert_text 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show message link when visitor blocking profile owner' do
    create(:blocking, blocker: @current_user, blocked: @other)
    visit profile_path(@other)

    assert_no_selector 'a', text: 'envía un mensaje privado a other'
    assert_equal profile_path(@other), current_path
  end

  it 'does not show ad in listings when visitor is blocked' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) { visit root_path }

    assert_no_text ad.title
  end

  it 'does not show ad page when visitor is blocked' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    assert_text 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show send message link in ad page when blocked by user' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @current_user, blocked: @other)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    assert_no_selector 'a', text: 'Envía un mensaje privado a other'
    assert_equal ad_path(ad), current_path
  end

  it 'does not show conversations with her when blocked by user' do
    create(:conversation, originator: @current_user, recipient: @other)
    create(:blocking, blocker: @other, blocked: @current_user)

    visit conversations_path
    refute_selector 'tr.mail'
  end

  it 'does not show comment textarea when visitor blocking ad author' do
    ad = create(:ad, user: @other, comments_enabled: true)
    create(:blocking, blocker: @current_user, blocked: @other)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    refute_selector '.ad_comment_form'
    assert_equal ad_path(ad), current_path
  end
end
