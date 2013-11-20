require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include Devise::TestHelpers

  test "don't sign in a locked user" do
    sign_in users(:three)
  end
  
  test "let sign in a non locked user" do
    sign_in users(:one)
  end

end
