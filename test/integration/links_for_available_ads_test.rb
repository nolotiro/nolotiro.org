require 'test_helper'

class LinksForAvailableAdsTest < ActionDispatch::IntegrationTest
  before { @ad = FactoryGirl.create(:ad, status: 1, comments_enabled: true) }

  it 'shows message link in listings' do
    visit ads_woeid_path(id: 766_273, type: 'give', status: 'available')

    assert page.has_content?('Envía un mensaje privado al anunciante')
  end

  it 'shows message link in ads' do
    visit ad_path(@ad)

    assert page.has_content?('Envía un mensaje privado al anunciante')
  end

  it 'shows comment form in ads' do
    visit ad_path(@ad)

    assert page.has_content?('accede para escribir un comentario')
  end
end
