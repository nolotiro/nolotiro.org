# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class LocationControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @user = FactoryGirl.create(:user)
    @request.headers['REMOTE_ADDR'] = '87.223.138.147'
  end

  test 'should get ask location' do
    get :ask
    assert_response :success
  end

  test 'should get location suggestion list' do
    mocking_yahoo_woeid_similar('tenerife') do
      get :list, location: 'tenerife'
      assert_response :success
    end
  end

  test 'should get location suggestion list (with post)' do
    mocking_yahoo_woeid_similar('tenerife') do
      post :list, location: 'tenerife'
      assert_response :success
    end
  end

  test 'should set location in my user' do
    sign_in @user
    post :change, location: 288_888
    assert_response :redirect
    assert_redirected_to ads_woeid_path(288_888, type: 'give')
  end

  test 'should set location in my session' do
    post :change, location: 288_888
    assert_response :redirect
    assert_redirected_to ads_woeid_path(288_888, type: 'give')
  end
end
