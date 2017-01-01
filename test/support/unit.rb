# frozen_string_literal: true

module ActiveSupport
  #
  # Base class for unit testing
  #
  class TestCase
    include FactoryGirl::Syntax::Methods

    self.use_transactional_tests = false

    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end
