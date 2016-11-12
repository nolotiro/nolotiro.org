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
    post :create, ad: { body: 'Es una Ferrari de esas rojas, muy linda.',
                        title: 'Regalo Ferrari',
                        type: 'give',
                        woeid_code: '788273' }

    assert_redirected_to new_user_session_url
  end

  test 'should create ad if logged in' do
    sign_in @user

    assert_difference('Ad.count') do
      post :create, ad: { body: 'Es una Ferrari de esas rojas, muy linda.',
                          title: 'Regalo Ferrari',
                          type: 'give',
                          woeid_code: '788273' }
    end

    assert_redirected_to adslug_path(assigns(:ad), slug: 'regalo-ferrari')
  end

  test 'should show ad' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, id: @ad.id, slug: @ad.slug

      assert_response :success
    end
  end

  test 'redirects to slugged version from non-slugged one' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :legacy_show, id: @ad.id

      assert_response :redirect
      assert_redirected_to adslug_path(@ad, slug: @ad.slug)
    end
  end

  test 'redirects to new slugged URL after title changes' do
    old_slug = @ad.slug
    @ad.update!(title: 'My new title, mistyped something')

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, id: @ad.id, slug: old_slug

      assert_response :redirect
      assert_redirected_to adslug_path(@ad, slug: @ad.slug)
    end
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

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
    assert_equal body, @ad.reload.body
  end

  test 'should update any ad as admin' do
    sign_in @admin
    patch :update, id: @ad, ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code }

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end

  test 'should not destroy ad as anonymous' do
    assert_difference('Ad.count', 0) { delete :destroy, id: @ad }
    assert_redirected_to root_path
  end

  test 'should not destroy non-owned ads as normal user' do
    sign_in @user

    assert_difference('Ad.count', 0) { delete :destroy, id: @ad }
    assert_redirected_to root_path
  end
end
