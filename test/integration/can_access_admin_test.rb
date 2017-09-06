# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class CanAccessAdmin < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include WebMocking

  it 'should not get /admin/jobs as a anonymous user' do
    visit '/admin/jobs'
    assert_text 'Para publicar anuncios o enviar mensajes accede a tu cuenta'
  end

  it 'should not get /admin/jobs as a normal user' do
    login_as user
    assert_raises(ActionController::RoutingError) { visit '/admin/jobs' }
    logout
  end

  it 'should get /admin/jobs as admin' do
    login_as admin
    visit '/admin/jobs'
    assert_text 'Sidekiq'
    assert_text 'Redis'
    assert_text 'Memory Usage'
    logout
  end

  it 'should not get /admin as a anonymous user' do
    visit '/admin'
    assert_text I18n.t('devise.failure.unauthenticated')
  end

  it 'should not get /admin as a normal user' do
    login_as user
    mocking_yahoo_woeid_info(user.woeid) { visit '/admin' }
    assert_text I18n.t('nlt.permission_denied')
    logout
  end

  it 'links to the main site from the admin' do
    login_as admin
    visit '/admin'

    assert_selector 'a[href="/"]'
    logout
  end

  private

  def user
    @user ||= create(:user)
  end

  def admin
    @admin ||= create(:admin)
  end
end
