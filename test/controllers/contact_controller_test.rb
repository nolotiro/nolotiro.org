require 'test_helper'

class ContactControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "should get contact form" do
    get :new
    assert_response :success
  end

  test "should verify recaptcha in contact form" do
    post :create, contact: {email: "hola@mundo.com", message: "hola mundo. hola mundo. hola mundo. hola mundo. hola mundo. hola mundo. hola mundo."}
    assert_redirected_to root_path
    assert_equal( I18n.t('nlt.contact_thanks'), flash[:notice] )
  end

end
