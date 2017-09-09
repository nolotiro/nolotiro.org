# frozen_string_literal: true

require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  it 'gets contact form' do
    get :new

    assert_response :success
  end

  it 'verifies recaptcha in contact form' do
    post :create,
         params: {
           contact: { email: 'hola@mundo.com', message: 'hola mundo. hola mundo. hola mundo. hola mundo. hola mundo. hola mundo. hola mundo.' }
         }

    assert_redirected_to root_path
    assert_equal I18n.t('nlt.contact_thanks'), flash[:notice]
  end
end
