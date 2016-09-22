# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class LinksForAds < ActionDispatch::IntegrationTest
  include WebMocking

  it 'shows message link in available ads' do
    within_ad_page(create(:ad, :available)) do
      assert_text 'Envía un mensaje privado al anunciante'
    end
  end

  it 'does not show message link in booked ads' do
    within_ad_page(create(:ad, :booked)) do
      assert_no_text 'Envía un mensaje privado al anunciante'
    end
  end

  it 'does not show message link in delivered ads' do
    within_ad_page(create(:ad, :delivered)) do
      assert_no_text 'Envía un mensaje privado al anunciante'
    end
  end

  private

  def within_ad_page(ad)
    mocking_yahoo_woeid_info(ad.woeid_code) do
      visit ad_path(ad)

      yield
    end
  end
end
