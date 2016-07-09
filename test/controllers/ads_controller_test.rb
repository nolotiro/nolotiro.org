# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class AdsControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
    @user = create(:user)
    @admin = create(:admin)
  end

  test 'should get index' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      @request.headers['REMOTE_ADDR'] = '87.223.138.147'
      get :index

      assert_response :success
      assert_not_nil assigns(:ads)
    end
  end

  test 'should not get new if not signed in' do
    get :new

    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'should get new if signed in' do
    mocking_yahoo_woeid_info(@user.woeid) do
      sign_in @user
      get :new

      assert_response :success
    end
  end

  test 'should not create ad if not signed in' do
    post :create, ad: { body: 'Es una Ferrari de esas rojas, muy linda.', title: 'Regalo Ferrari', type: 1, woeid_code: '788273' }

    assert_redirected_to new_user_session_url
  end

  test 'should create ad if logged in' do
    sign_in @user

    assert_difference('Ad.count') do
      post :create, ad: { body: 'Es una Ferrari de esas rojas, muy linda.', title: 'Regalo Ferrari', type: 1, woeid_code: '788273' }
    end

    assert_redirected_to adslug_path(assigns(:ad), slug: 'regalo-ferrari')
  end

  test 'should show ad' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, id: @ad.id

      assert_response :success
    end
  end

  test 'only ad owner should bump ads' do
    @ad.update!(published_at: 6.days.ago)
    sign_in @user
    post :bump, id: @ad

    assert_equal 6.days.ago.to_date, @ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should not bump ads too recent' do
    @ad.update!(user_owner: @user.id, published_at: 4.days.ago)
    sign_in @user
    post :bump, id: @ad

    assert_equal 4.days.ago.to_date, @ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should bump adds old enough' do
    original_path = ads_woeid_path(id: @user.woeid, type: @ad.type)
    request.env['HTTP_REFERER'] = original_path
    @ad.update!(user_owner: @user.id, published_at: 6.days.ago)
    sign_in @user
    post :bump, id: @ad

    assert_equal Time.zone.now.to_date, @ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to original_path
  end

  test 'should not edit any ad as normal user' do
    @ad.update!(user_owner: @admin.id)
    sign_in @user
    get :edit, id: @ad

    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'should edit my own ad as normal user' do
    @ad.update!(user_owner: @user.id)
    sign_in @user
    get :edit, id: @ad

    assert_response :success
  end

  test 'should get edit as admin user' do
    sign_in @admin
    get :edit, id: @ad

    assert_response :success
  end

  test 'should not update other user ad if normal user' do
    @ad.update!(user_owner: @admin.id)
    sign_in @user
    patch :update, id: @ad, ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code }

    assert_redirected_to root_url
  end

  test 'should update own ads as normal user' do
    sign_in @user
    @ad.update!(user_owner: @user.id)

    body = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
    patch :update, id: @ad, ad: { body: body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code }

    assert_redirected_to ad_path(assigns(:ad))
    @ad.reload
    assert_equal body, @ad.body
  end

  test 'should update any ad as admin' do
    sign_in @admin
    patch :update, id: @ad, ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code }

    assert_redirected_to ad_path(assigns(:ad))
  end

  test 'should not destroy ad as anonymous' do
    assert_difference('Ad.count', 0) { delete :destroy, id: @ad }
    assert_redirected_to new_user_session_url
  end

  test 'should not destroy non-owned ads as normal user' do
    sign_in @user

    assert_difference('Ad.count', 0) { delete :destroy, id: @ad }
    assert_redirected_to root_path
  end

  test 'should destroy owned ads as normal user' do
    @ad.update!(user_owner: @user.id)
    sign_in @user

    assert_difference('Ad.count', -1) { delete :destroy, id: @ad }
    assert_redirected_to ads_path
  end

  test 'should destroy ad as admin user' do
    sign_in @admin

    assert_difference('Ad.count', -1) { delete :destroy, id: @ad }
    assert_redirected_to ads_path
  end
end
