# frozen_string_literal: true

require "test_helper"

class PageControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  it "gets faqs" do
    get :faqs
    assert_response :success
  end

  it "gets rules" do
    get :rules
    assert_response :success
  end

  it "gets about" do
    get :about
    assert_response :success
  end

  it "gets privacy" do
    get :privacy
    assert_response :success
  end

  it "gets translate" do
    get :translate
    assert_response :success
  end

  it "gets legal" do
    get :legal
    assert_response :success
  end
end
