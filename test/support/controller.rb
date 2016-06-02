#
# Base class for controller testing
#
class ActionController::TestCase
  include Devise::TestHelpers

  after { Rails.cache.clear }
end
