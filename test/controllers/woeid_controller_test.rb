# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class WoeidControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
  end

  test 'should get listall and give (available, delivered, booked)' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, type: 'give', status: 'available'
      assert_response :success
      get :show, type: 'give', status: 'booked'
      assert_response :success
      get :show, type: 'give', status: 'delivered'
      assert_response :success
      assert_generates '/ad/listall/ad_type/give',
                       { controller: 'woeid', action: 'show', type: 'give' }
    end
  end

  test 'should get WOEID and give (available, delivered, booked)' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, type: 'give', status: 'available', id: @ad.woeid_code
      assert_response :success
      get :show, type: 'give', status: 'booked', id: @ad.woeid_code
      assert_response :success
      get :show, type: 'give', status: 'delivered', id: @ad.woeid_code
      assert_response :success
    end
  end

  test 'should get WOEID and want' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, type: 'want', id: @ad.woeid_code
      assert_response :success
    end
  end

end
