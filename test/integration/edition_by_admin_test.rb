# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class EditionsByAdmin < ActionDispatch::IntegrationTest
  include WebMocking
  include Authentication

  before do
    @ad = FactoryGirl.create(:ad, woeid_code: 766_273, type: 1)
    login_as FactoryGirl.create(:admin, woeid: 766_272)
  end

  it 'changes only the edited attribute' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit ads_edit_path(@ad)
      select 'busco...', from: 'ad_type'
      click_button 'Enviar'

      assert_equal 766_273, @ad.reload.woeid_code
      assert_equal 2, @ad.reload.type
    end
  end
end
