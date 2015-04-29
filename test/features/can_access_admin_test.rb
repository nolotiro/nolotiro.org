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
    visit "/admin/jobs"
    save_and_open_page
    #page.must_redirect_to root_url
    assert_equal 404, page.status_code
  end

  scenario "should get /admin/jobs as admin" do
    @admin = FactoryGirl.create(:admin)
    login_as @admin
    visit "/admin/jobs"
    page.must_have_content "Sidekiq"
    page.must_have_content "Redis"
    page.must_have_content "Memory Usage"
  end

end
