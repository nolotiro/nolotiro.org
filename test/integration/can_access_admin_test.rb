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
    assert_text 'Tienes que iniciar sesión o registrarte para poder continuar'
  end

  it 'should not get /admin as a normal user' do
    login_as user
    mocking_yahoo_woeid_info(user.woeid) { visit '/admin' }
    assert_text 'No tienes permisos para realizar esta acción'
    logout
  end

  it 'does not link to the admin from the main site for anonymous users' do
    visit root_path

    assert_no_selector 'a[href="/admin?locale=es"]'
  end

  it 'does not link to the admin from the main site for non admins' do
    login_as user
    visit root_path

    assert_no_selector 'a[href="/admin?locale=es"]'
    logout
  end

  it 'links to the admin from the main site for admins' do
    login_as admin
    visit root_path

    assert_selector 'a[href="/admin?locale=es"]'
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
    # TODO: :stateless to prevent API queries. Remove when we get rid of Yahoo
    @user ||= create(:user, :stateless)
  end

  def admin
    @admin ||= create(:admin)
  end
end
