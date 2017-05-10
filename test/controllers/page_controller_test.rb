# frozen_string_literal: true

require 'test_helper'

class PageControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  it 'should get faqs' do
    get :faqs
    assert_response :success
  end

  it 'should get rules' do
    get :rules
    assert_response :success
  end

  it 'should get about' do
    get :about
    assert_response :success
  end

  it 'should get privacy' do
    get :privacy
    assert_response :success
  end

  it 'should get translate' do
    get :translate
    assert_response :success
  end

  it 'should get legal' do
    get :legal
    assert_response :success
  end
end
