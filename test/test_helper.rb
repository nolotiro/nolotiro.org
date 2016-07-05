ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'capybara/rails'
require 'support/phantomjs'

require 'support/unit'
require 'support/controller'
require 'support/integration'

# Configure database cleaning
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init

# Ensure phantomjs executable is available
Phantomjs.check
