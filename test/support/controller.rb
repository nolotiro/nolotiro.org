#
# Base class for controller testing
#
class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  after { Rails.cache.clear }
end
