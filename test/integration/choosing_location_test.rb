# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class ChoosingLocationTest < ActionDispatch::IntegrationTest
  include WebMocking
  include Authentication

  it 'suggests locations matching name' do
    mocking_yahoo_woeid_similar('tenerife') do
      choose_location('tenerife')

      assert_text 'Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)'
    end
  end

  it 'chooses between locations matching name' do
    mocking_yahoo_woeid_similar('tenerife') do
      choose_location('tenerife')

      select 'Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)'
      click_button 'Elige tu ubicación'

      assert_text 'regalo - Santa Cruz de Tenerife, Islas Canarias, España'
    end
  end

  it "directly chooses location when there's a single match" do
    mocking_yahoo_woeid_similar('tenerife_unique') do
      visit location_ask_path
      fill_in 'location', with: 'tenerife, islas canarias'
      click_button 'Enviar'

      assert_text 'regalo - Santa Cruz de Tenerife, Islas Canarias, España'
    end
  end

  it 'directly chooses location through GET request' do
    mocking_yahoo_woeid_similar('tenerife_unique') do
      visit location_change_path(location: 'tenerife, islas canarias')

      assert_text 'regalo - Santa Cruz de Tenerife, Islas Canarias, España'
    end
  end

  it 'memorizes chosen location in the user' do
    user = create(:user)
    login_as user

    mocking_yahoo_woeid_similar('tenerife') do
      choose_location('tenerife')

      select 'Santa Cruz de Tenerife, Islas Canarias, España (0 anuncios)'
      click_button 'Elige tu ubicación'
      logout
      login_as user

      assert_text 'regalo - Santa Cruz de Tenerife, Islas Canarias, España'
    end
  end

  private

  def choose_location(name)
    visit location_ask_path
    fill_in 'location', with: name
    click_button 'Enviar'
  end
end
