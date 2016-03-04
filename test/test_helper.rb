ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/pride'
require 'minitest/rails/capybara'
include Warden::Test::Helpers

Capybara.javascript_driver = :webkit
Warden.test_mode!
DatabaseCleaner.strategy = :transaction
#DatabaseCleaner.strategy = :truncation

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
