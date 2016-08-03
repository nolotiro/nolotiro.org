# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class LinksForBookedAdsTest < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    @ad = create(:ad, status: 2, comments_enabled: true)
    @woeid_code = @ad.woeid_code
  end

  it 'does not show message link in ads' do
    mocking_yahoo_woeid_info(@woeid_code) do
      visit ad_path(@ad)

      refute page.has_content?('Envía un mensaje privado al anunciante')
    end
  end

  it 'shows comment form in ads' do
    mocking_yahoo_woeid_info(@woeid_code) do
      visit ad_path(@ad)

      assert page.has_content?('accede para escribir un comentario')
    end
  end
end
