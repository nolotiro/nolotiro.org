ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

if ENV.keys.grep(/ZEUS/).any?
  require 'minitest/unit'
  MiniTest::Unit.class_variable_set("@@installed_at_exit", true)
end

require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

end
