require 'test_helper'
require 'support/web_mocking'

class LinksForDeliveredAds < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    @ad = FactoryGirl.create(:ad, status: 3, comments_enabled: true)
    @woeid_code = @ad.woeid_code
  end

  it 'does not show message link in listings' do
    visit ads_woeid_path(id: @woeid_code, type: 'give', status: 'delivered')

    refute page.has_content?('Envía un mensaje privado al anunciante')
  end

  it 'does not show message link in ads' do
    mocking_yahoo_woeid_info(@woeid_code) do
      visit ad_path(@ad)

      refute page.has_content?('Envía un mensaje privado al anunciante')
    end
  end

  it 'does not show comment link in ads' do
    mocking_yahoo_woeid_info(@woeid_code) do
      visit ad_path(@ad)

      refute page.has_content?('accede para escribir un comentario')
    end
  end
end
