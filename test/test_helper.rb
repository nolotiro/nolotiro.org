ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/reporters'
require 'minitest/rails/capybara'
Minitest::Reporters.use!

include Warden::Test::Helpers
Warden.test_mode!

class ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods
end

#class ActiveSupport::TestCase
#  ActiveRecord::Migration.check_pending!
#end

DatabaseCleaner.strategy = :transaction

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
