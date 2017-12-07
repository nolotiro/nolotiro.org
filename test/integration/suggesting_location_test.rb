# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/geo'
require 'support/web_mocking'

class SuggestingLocationTest < ActionDispatch::IntegrationTest
  include Geo
  include WebMocking

  before do
    Capybara.current_driver = Capybara.javascript_driver
    page.driver.add_headers('X_FORWARDED_FOR' => '83.39.208.18')

    visit root_path
  end

  after { Capybara.current_driver = Capybara.default_driver }

  it 'shows a link to show ads in the guessed location' do
    assert_link 'Ver anuncios en Madrid'
  end

  it 'directly chooses location from IP suggestion' do
    mocking_yahoo_woeid_similar('madrid_unique') do
      click_link 'Ver anuncios en Madrid'
    end

    assert_location_page 'Madrid, Madrid, España'
  end
end
