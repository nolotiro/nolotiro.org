# frozen_string_literal: true

require "test_helper"
require "support/web_mocking"
require "integration/concerns/geo"
require "integration/concerns/login_helper"

class ChoosingLocationTest < ActionDispatch::IntegrationTest
  include WebMocking
  include LoginHelper
  include Geo

  it "redirects there when user logged in and no location set" do
    login_as create(:user, :stateless)
    visit root_path

    assert_selector "h1", text: "Cambia tu ciudad"
  end

  it "suggests locations matching name" do
    mocking_yahoo_woeid_similar("tenerife") do
      choose_location("tenerife")

      assert_text "Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)"
    end
  end

  it "shows a message when no matching locations are found" do
    mocking_yahoo_woeid_similar("tenerifa") do
      choose_location("tenerifa")

      assert_text "No se han encontrado ubicaciones con el nombre tenerifa"
    end
  end

  it "shows an error message when submitted without a search" do
    choose_location("")

    assert_text "No se han encontrado ubicaciones con el nombre"
  end

  it "chooses between locations matching name" do
    mocking_yahoo_woeid_similar("tenerife") { choose_location("tenerife") }

    mocking_yahoo_woeid_info(773_692) do
      select "Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)"
      click_button "Elige tu ubicación"

      assert_location_page "Santa Cruz de Tenerife, Islas Canarias, España"
    end
  end

  it "directly chooses location when there's a single match" do
    mocking_yahoo_woeid_similar("tenerife_unique") do
      choose_location("tenerife, islas canarias")

      assert_location_page "Santa Cruz de Tenerife, Islas Canarias, España"
    end
  end

  it "directly chooses location through GET request" do
    mocking_yahoo_woeid_similar("tenerife_unique") do
      visit location_change_path(location: "tenerife, islas canarias")

      assert_location_page "Santa Cruz de Tenerife, Islas Canarias, España"
    end
  end

  it "memorizes chosen location in the user" do
    user = create(:user)
    login_as user

    mocking_yahoo_woeid_similar("tenerife_unique") do
      choose_location("tenerife, islas canarias")
      relogin_as user

      assert_location_page "Santa Cruz de Tenerife, Islas Canarias, España"
    end

    logout
  end

  private

  def choose_location(name)
    visit location_ask_path
    fill_in "location", with: name
    click_button "Enviar"
  end
end
