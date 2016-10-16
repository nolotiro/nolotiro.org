# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class WoeidTest < ActionDispatch::IntegrationTest
  include WebMocking

  it 'returns a hard 404 error if woeid is not type town' do
    create(:town, :madrid)

    assert_raise(ActiveRecord::RecordNotFound) do
      get '/es/woeid/12578024/give' # woeid of Madrid State
    end
  end

  it 'returns a hard 404 error if woeid is not an integer' do
    assert_raise(ActionController::RoutingError) do
      get '/es/woeid/234LOOOOOOOOOOOOL24801/give'
    end
  end

  it 'returns a hard 404 error if woeid does not exist' do
    assert_raise(ActiveRecord::RecordNotFound) do
      get '/es/woeid/222222/give'
    end
  end
end
