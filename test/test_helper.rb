ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'capybara/rails'

# Configure database cleaning
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  self.use_transactional_fixtures = false

  def setup
    DatabaseCleaner.start
    I18n.default_locale = :es
    I18n.locale = :es
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  after { Rails.cache.clear }
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    {:locale => I18n.default_locale }
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  after do
    Capybara.reset_sessions!
    Rails.cache.clear
  end
end
