require 'test_helper'

class ContactControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "should get contact form" do
    get :new
    assert_response :success
  end

  test "should verify recaptcha in contact form" do
    post :create, contact: {mail: "hola@mundo.com", message: "hola mundo"}
    assert_response :success
  end

end
