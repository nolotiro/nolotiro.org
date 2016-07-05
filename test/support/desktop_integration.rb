require 'support/web_mocking'

Capybara.register_driver :poltergeist_desktop do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    window_size: [1366, 768],
    url_blacklist: WebMocking.js_resource_blacklist,
    phantomjs: Phantomjs.path
  )
end

class DesktopIntegrationTest < ActionDispatch::IntegrationTest
  before do
    Capybara.javascript_driver = :poltergeist_desktop
    Capybara.current_driver = Capybara.javascript_driver
  end

  after { Capybara.current_driver = Capybara.default_driver }
end
