# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class LocationControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  def test_asks_location
    get :ask
    assert_response :success
  end

  def test_gets_location_suggestion_list
    mocking_yahoo_woeid_similar('tenerife') do
      get :list, location: 'tenerife'
      assert_response :success
    end
  end

  def test_gets_location_suggestion_list_with_post
    mocking_yahoo_woeid_similar('tenerife') do
      post :list, location: 'tenerife'
      assert_response :success
    end
  end

  def test_sets_location_in_my_user
    sign_in create(:user)
    post :change, location: 288_888
    assert_response :redirect
    assert_redirected_to ads_woeid_path(288_888, type: 'give')
  end
end
