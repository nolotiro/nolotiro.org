ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/reporters'
require 'minitest/rails/capybara'
include Warden::Test::Helpers

Minitest::Reporters.use!
Capybara.javascript_driver = :webkit
Warden.test_mode!
DatabaseCleaner.strategy = :transaction
#DatabaseCleaner.strategy = :truncation

class ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods
end

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end
  after :each do
    DatabaseCleaner.clean
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    {:locale => I18n.default_locale }
  end
end

# FIX Capybara error: SQLite3::BusyException: database is locked  
# http://atlwendy.ghost.io/capybara-database-locked/
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

Rails.application.config.consider_all_requests_local = false
