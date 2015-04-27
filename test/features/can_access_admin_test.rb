require "test_helper"
include Warden::Test::Helpers

feature "CanAccessAdmin" do

  #scenario "the test is sound" do
  #  visit root_path
  #  page.must_have_content "Hello World"
  #  page.wont_have_content "Goobye All!"
  #end

  scenario "should not get /admin/jobs as a anonymous user" do
    visit "/admin/jobs"
    assert_equal 404, page.status_code
  end

  scenario "should not get /admin/jobs as a normal user" do
    @user = FactoryGirl.create(:user)
    login_as @user
    visit "/admin/jobs"
    page.must_redirect_to root_url
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
  end

  scenario "should get /admin/jobs as admin" do
    @admin = FactoryGirl.create(:admin)
    login_as @admin
    visit "/admin/jobs"
    page.must_have_content "Colas"
  end

end
