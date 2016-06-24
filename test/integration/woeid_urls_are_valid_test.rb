require "test_helper"

class WoeidUrlParamValid < ActionDispatch::IntegrationTest

  it "returns a hard 404 error if woeid is not type town" do
    assert_raise(ActionController::RoutingError) do
      get '/es/woeid/23424801/give' #woeid of Ecuador Country
    end
  end

  it "returns a hard 404 error if woeid is not an integer" do
    assert_raise(ActionController::RoutingError) do
      get '/es/woeid/234LOOOOOOOOOOOOL24801/give'
    end
  end

  it "returns a hard 404 error if woeid is not a valid woeid" do
    assert_raise(ActionController::RoutingError) do
      get '/es/woeid/222222/give' #woeid does not exist
    end
  end

end

