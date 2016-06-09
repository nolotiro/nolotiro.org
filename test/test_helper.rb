ENV["RAILS_ENV"] ||= "test"

#
# Dirty monkeypatch to prevent touching the network during tests
#
# @todo Keep speed and non network dependent tests, but remove also the
# monkeypatching
#
unless ENV['CI']
  module WoeidHelper
    def self.convert_woeid_name(_woeid)
      {
        full: 'Río de Janeiro, Rio de Janeiro, Brasil',
        short: 'Río de Janeiro'
      }
    end
  end

  module GeoPlanet
    class Place
      def self.search(_text, _options = {})
        [
          new('woeid' => 455825,
              'placeTypeName' => 'town',
              'placeTypeName attrs' => { 'code' => '7' },
              'name' => 'Río de Janeiro')
        ]
      end
    end
  end
end

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'capybara/rails'

require 'support/unit'
require 'support/controller'
require 'support/integration'

# Configure database cleaning
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init
