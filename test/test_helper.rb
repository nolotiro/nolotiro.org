ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'minitest/rails/capybara'

DatabaseCleaner.strategy = :transaction

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def setup
    I18n.default_locale = :es
    I18n.locale = :es
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    {:locale => I18n.default_locale }
  end
end
