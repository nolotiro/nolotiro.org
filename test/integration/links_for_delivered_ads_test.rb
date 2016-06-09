require 'test_helper'

class LinksForDeliveredAds < ActionDispatch::IntegrationTest
  before { @ad = FactoryGirl.create(:ad, status: 3, comments_enabled: true) }

  it 'does not show message link in listings' do
    visit ads_woeid_path(id: 766_273, type: 'give', status: 'delivered')

    refute page.has_content?('Envía un mensaje privado al anunciante')
  end

  it 'does not show message link in ads' do
    visit ad_path(@ad)

    refute page.has_content?('Envía un mensaje privado al anunciante')
  end

  it 'does not show comment link in ads' do
    visit ad_path(@ad)

    refute page.has_content?('accede para escribir un comentario')
  end
end
