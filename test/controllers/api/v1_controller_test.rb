require 'test_helper'

class Api::V1ControllerTest < ActionController::TestCase

  test "should get ad show on api v1" do
    get :api_v1_ad_show
    assert_response :success
    assert_not_nil assigns(:ads)
  end

end

