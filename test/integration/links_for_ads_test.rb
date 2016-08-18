# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class LinksForAds < ActionDispatch::IntegrationTest
  include WebMocking

  before { @ad = create(:ad, comments_enabled: true) }

  it 'shows message link in available ads' do
    @ad.update(status: 1)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit ad_path(@ad)

      assert_text 'Envía un mensaje privado al anunciante'
    end
  end

  it 'does not show message link in booked ads' do
    @ad.update(status: 2)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit ad_path(@ad)

      assert_no_text 'Envía un mensaje privado al anunciante'
    end
  end

  it 'does not show message link in delivered ads' do
    @ad.update(status: 3)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit ad_path(@ad)

      assert_no_text 'Envía un mensaje privado al anunciante'
    end
  end
end
