require "test_helper"
include Warden::Test::Helpers

feature "CanAccessAdmin" do

  scenario "should not get /admin/jobs as a anonymous user" do
    visit "/admin/jobs"
    page.must_have_content "Para publicar anuncios o enviar mensajes accede a tu cuenta"
  end

  scenario "should not get /admin/jobs as a normal user" do
    @user = FactoryGirl.create(:user)
    login_as @user
    assert_raises(ActionController::RoutingError) { visit "/admin/jobs" }
  end

  scenario "should get /admin/jobs as admin" do
    @admin = FactoryGirl.create(:admin)
    login_as @admin
    visit "/admin/jobs"
    page.must_have_content "Sidekiq"
    page.must_have_content "Redis"
    page.must_have_content "Memory Usage"
  end

  scenario "should not get /admin as a anonymous user" do
    visit "/admin"
    page.must_have_content I18n.t('devise.failure.unauthenticated')
  end

  scenario "should not get /admin as a normal user" do
    @user = FactoryGirl.create(:user)
    login_as @user
    visit "/admin"
    page.must_have_content I18n.t('nlt.permission_denied')
  end

  scenario "should get /admin as admin" do
    @admin = FactoryGirl.create(:admin)
    login_as @admin
    visit "/admin"
    page.must_have_content "Últimos anuncios publicados"
  end

end
