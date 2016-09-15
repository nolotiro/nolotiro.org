# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'minitest/around/spec'
require 'capybara/rails'
require 'support/phantomjs'

require 'support/unit'
require 'support/controller'
require 'support/integration'

# Configure database cleaning
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

# Ensure phantomjs executable is available
Phantomjs.check
