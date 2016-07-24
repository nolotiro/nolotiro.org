# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class LinksForAvailableAdsTest < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    @ad = create(:ad, status: 1, comments_enabled: true)
    @woeid_code = @ad.woeid_code
  end

  it 'shows message link in ads' do
    mocking_yahoo_woeid_info(@woeid_code) do
      visit ad_path(@ad)

      assert_content 'Envía un mensaje privado al anunciante'
    end
  end
end
