require 'test_helper'

class PageControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "should get faqs" do
    get :faqs
    assert_response :success
  end

  test "should get tos" do
    get :tos
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
  end

  test "should get translate" do
    get :translate
    assert_response :success
  end

  test "should get legal" do
    get :legal
    assert_response :success
  end

end
