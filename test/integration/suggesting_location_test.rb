# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/geo'

class SuggestingLocationTest < ActionDispatch::IntegrationTest
  include Geo

  before { Capybara.current_driver = Capybara.javascript_driver }

  after { Capybara.current_driver = Capybara.default_driver }

  it 'shows a link to show ads in the guessed location' do
    in_madrid do
      visit root_path

      assert_selector 'a', text: 'Ver anuncios en Madrid'
    end
  end

  it 'directly chooses location from IP suggestion' do
    in_madrid do
      visit root_path
      click_link 'Ver anuncios en Madrid'

      assert_location_page 'Madrid, Comunidad de Madrid, España'
    end
  end

  it 'works when suggestion name does not match internal name' do
    #
    # Factory name is "Barcelona, Catalunya, España", MaxMind name is
    # "Barcelona, Cataluña, España". We don't care, location switch should work
    #
    in_barcelona do
      visit root_path
      click_link 'Ver anuncios en Barcelona'

      assert_location_page 'Barcelona, Catalunya, España'
    end
  end

  private

  def in_madrid
    page.driver.add_headers('X_FORWARDED_FOR' => '83.39.207.18')
    create(:town, :madrid)

    yield
  end

  def in_barcelona
    page.driver.add_headers('X_FORWARDED_FOR' => '80.102.133.241')
    create(:town, :barcelona)

    yield
  end
end
