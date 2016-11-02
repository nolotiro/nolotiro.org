# frozen_string_literal: true

Capybara.register_driver :poltergeist_mobile do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [320, 480],
                                         url_whitelist: ['127.0.0.1'])
end

class MobileIntegrationTest < ActionDispatch::IntegrationTest
  before do
    Capybara.javascript_driver = :poltergeist_mobile
    Capybara.current_driver = Capybara.javascript_driver
  end

  after { Capybara.current_driver = Capybara.default_driver }
end
