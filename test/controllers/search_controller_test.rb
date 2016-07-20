# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class SearchControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup { @ad = FactoryGirl.create(:ad) }

  test 'search works with a WOEID code param' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :search, q: 'ordenador', woeid_code: @ad.woeid_code
      assert_response :success
    end
  end

  test 'search works with a WOEID code param - no results' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :search, q: 'notfound', woeid_code: @ad.woeid_code
      assert_response :success
    end
  end

  test 'redirects to home page when no WOEID code param specified' do
    get :search, q: 'ordenador'
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'redirects to home page when no WOEID param nor query' do
    get :search
    assert_response :redirect
    assert_redirected_to root_path
  end
end
