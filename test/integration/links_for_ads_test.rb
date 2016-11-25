# frozen_string_literal: true

require 'test_helper'
require 'support/ads'

class LinksForAds < ActionDispatch::IntegrationTest
  include AdTestHelpers

  it 'shows message link in available ads' do
    visit_ad_page(create(:ad, :available))

    assert_text 'Envía un mensaje privado al anunciante'
  end

  it 'does not show message link in booked ads' do
    visit_ad_page(create(:ad, :booked))

    assert_no_text 'Envía un mensaje privado al anunciante'
  end

  it 'does not show message link in delivered ads' do
    visit_ad_page(create(:ad, :delivered))

    assert_no_text 'Envía un mensaje privado al anunciante'
  end

  it 'shows message link in petition ads' do
    visit_ad_page(create(:ad, :want))

    assert_text 'Envía un mensaje privado al anunciante'
  end
end
