ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/spec'

Turn.config.trace = 5

if ENV.keys.grep(/ZEUS/).any?
  require 'minitest/unit'
  MiniTest::Unit.class_variable_set("@@installed_at_exit", true)
end

require 'rails/test_help'

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
