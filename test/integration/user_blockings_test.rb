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

  it 'shows block link in profile after unblocking user' do
    create(:blocking, blocker: @current_user, blocked: @other)
    visit profile_path(@other)
    click_link 'desbloquear a other'

    assert_link 'bloquear a other'
    refute_link 'desbloquear a other'
  end

  it 'shows unblock link in profile after blocking user' do
    visit profile_path(@other)
    click_link 'bloquear a other'

    assert_link 'desbloquear a other'
    refute_link 'bloquear a other'
  end

  it 'does not show profile page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) { visit profile_path(@other) }

    assert_content 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show listads page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit listads_user_path(@other)
    end

    assert_content 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show message link when visitor blocking profile owner' do
    create(:blocking, blocker: @current_user, blocked: @other)
    visit profile_path(@other)

    refute_link 'envía un mensaje privado a other'
    assert_equal profile_path(@other), current_path
  end

  it 'does not show ad in listings when visitor is blocked' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) { visit root_path }

    refute_content ad.title
  end

  it 'does not show ad page when visitor is blocked' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    assert_content 'No tienes permisos para realizar esta acción'
    assert_equal ads_woeid_path(@current_user.woeid, type: 'give'), current_path
  end

  it 'does not show send message link in ad page when blocked by user' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @current_user, blocked: @other)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    refute_link 'Envía un mensaje privado al anunciante'
    assert_equal ad_path(ad), current_path
  end
end
