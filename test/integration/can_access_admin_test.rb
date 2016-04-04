require "test_helper"
require "integration/concerns/authentication"

class CanAccessAdmin < ActionDispatch::IntegrationTest
  include Authentication

  it "should not get /admin/jobs as a anonymous user" do
    visit "/admin/jobs"
    page.must_have_content "Para publicar anuncios o enviar mensajes accede a tu cuenta"
  end

  it "should not get /admin/jobs as a normal user" do
    login_as user
    assert_raises(ActionController::RoutingError) { visit "/admin/jobs" }
  end

  it "should get /admin/jobs as admin" do
    login_as admin
    visit "/admin/jobs"
    page.must_have_content "Sidekiq"
    page.must_have_content "Redis"
    page.must_have_content "Memory Usage"
  end

  it "should not get /admin as a anonymous user" do
    visit "/admin"
    page.must_have_content I18n.t('devise.failure.unauthenticated')
  end

  it "should not get /admin as a normal user" do
    login_as user
    visit "/admin"
    page.must_have_content I18n.t('nlt.permission_denied')
  end

  it "should get /admin as admin" do
    login_as admin
    visit "/admin"
    page.must_have_content "Últimos anuncios publicados"
  end

  private

  def user
    @user ||= FactoryGirl.create(:user)
  end

  def admin
    @admin ||= FactoryGirl.create(:admin)
  end
end
