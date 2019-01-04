# frozen_string_literal: true

require 'test_helper'

class CanAccessAdmin < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  it "should not get /admin/jobs as a anonymous user" do
    visit "/admin/jobs"
    assert_text "Para publicar anuncios o enviar mensajes accede a tu cuenta"
  end

  it "should not get /admin/jobs as a normal user" do
    login_as user
    assert_raises(ActionController::RoutingError) { visit "/admin/jobs" }
    logout
  end

  it "should get /admin/jobs as admin" do
    login_as admin
    visit "/admin/jobs"
    assert_text "Sidekiq"
    assert_text "Redis"
    assert_text "Memory Usage"
    logout
  end

  it "should not get /admin as a anonymous user" do
    visit "/admin"
    assert_text "Tienes que iniciar sesión o registrarte para poder continuar"
  end

  it "should not get /admin as a normal user" do
    login_as user
    visit '/admin'
    assert_text I18n.t('nlt.permission_denied')
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
