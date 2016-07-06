# frozen_string_literal: true
module ActionController
  #
  # Base class for controller testing
  #
  class TestCase
    include Devise::Test::ControllerHelpers

    after { Rails.cache.clear }
  end
end
