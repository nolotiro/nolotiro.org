# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class WoeidTest < ActionDispatch::IntegrationTest
  include WebMocking

  it 'returns a hard 404 error if woeid is not type town' do
    mocking_yahoo_woeid_info(23_424_801) do
      assert_raise(ActionController::RoutingError) do
        get '/es/woeid/23424801/give' # woeid of Ecuador Country
      end
    end
  end

  it 'returns a hard 404 error if woeid is not an integer' do
    assert_raise(ActionController::RoutingError) do
      get '/es/woeid/234LOOOOOOOOOOOOL24801/give'
    end
  end

  it 'returns a hard 404 error if woeid does not exist' do
    mocking_yahoo_woeid_info(222_222) do
      assert_raise(ActionController::RoutingError) do
        get '/es/woeid/222222/give'
      end
    end
  end
end
