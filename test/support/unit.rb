#
# Base class for unit testing
#
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  self.use_transactional_fixtures = false

  def setup
    DatabaseCleaner.start
    I18n.default_locale = :es
    I18n.locale = :es
  end

  def teardown
    DatabaseCleaner.clean
  end
end
