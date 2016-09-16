# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/web_mocking'

class UserBlockingsTest < AuthenticatedTest
  include WebMocking

  before { @other = create(:user, username: 'other') }

  it 'does not show profile page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit profile_path(@other.username)
    end

    assert_access_denied
  end

  it 'does not show listads page when visitor is blocked' do
    create(:blocking, blocker: @other, blocked: @current_user)
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit listads_user_path(@other)
    end

    assert_access_denied
  end

  it 'does not show message link when visitor blocking profile owner' do
    create(:blocking, blocker: @current_user, blocked: @other)
    visit profile_path(@other.username)

    assert_no_selector 'a', text: 'envía un mensaje privado a other'
    assert_equal profile_path(@other.username), current_path
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

    assert_access_denied
  end

  it 'does not show send message link in ad page when blocked by user' do
    ad = create(:ad, user: @other)
    create(:blocking, blocker: @current_user, blocked: @other)
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    assert_no_selector 'a', text: 'envía un mensaje privado a other'
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

  private

  def assert_access_denied
    assert_text 'No tienes permisos para realizar esta acción'
    assert_equal root_path, current_path
  end
end
