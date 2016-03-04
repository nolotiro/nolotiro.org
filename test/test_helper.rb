ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'minitest/rails/capybara'

Capybara.javascript_driver = :webkit
DatabaseCleaner.strategy = :transaction

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init

class ActionController::TestCase
  include Devise::TestHelpers
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

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    {:locale => I18n.default_locale }
  end
end

# https://github.com/blowmage/minitest-rails-capybara/issues/6
class Capybara::Rails::TestCase
  before { self.use_transactional_fixtures = !metadata[:js] }
end
