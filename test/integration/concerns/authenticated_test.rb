# frozen_string_literal: true

class AuthenticatedTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  before do
    @current_user = create(:user)
    login_as(@current_user)
  end

  after { logout }
end
