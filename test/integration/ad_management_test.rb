# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/ads'

class AdManagementTest < AuthenticatedTest
  include AdTestHelpers

  it 'can have pictures of 5 megabytes or less' do
    with_file_of_size(5.megabytes) do |path|
      submit_ad_form(file_path: path)

      assert_no_text('Imagen debe estar entre 0 Bytes y 5 MB')
    end
  end

  it 'cannot have pictures bigger than 5 megabytes' do
    with_file_of_size(6.megabytes) do |path|
      submit_ad_form(file_path: path)

      assert_text('Imagen debe estar entre 0 Bytes y 5 MB')
    end
  end

  it 'republishes available ads' do
    ad = create(:ad, :available, user: @current_user, published_at: 6.days.ago)
    visit_ad_page(ad)
    click_link_by_label('Republicar')

    assert_text 'Anuncio republicado'
  end

  it 'republishes booked ads and changes status' do
    ad = create(:ad, :booked, user: @current_user, published_at: 6.days.ago)
    visit_ad_page(ad)
    click_link_by_label('Republicar')

    assert_text 'Anuncio republicado'
    assert_equal true, ad.reload.available?
  end

  it 'does not republish delivered ads' do
    ad = create(:ad, :delivered, user: @current_user, published_at: 6.days.ago)
    visit_ad_page(ad)

    assert_no_selector 'a', text: 'Republicar'
  end

  it 'does not republish delivered ads (direct request)' do
    ad = create(:ad, :delivered, user: create(:user), published_at: 6.days.ago)
    original_path = ads_woeid_path(ad.woeid_code, type: 'give')
    post ads_bump_path(ad), headers: { 'HTTP_REFERER' => original_path }

    assert_equal 6.days.ago.to_date, ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to original_path
  end

  it 'does not republish ads if not owner' do
    visit_ad_page(create(:ad, user: create(:user), published_at: 6.days.ago))

    assert_no_selector 'a', text: 'Republicar'
  end

  it 'does not republish ads if not owner (direct request)' do
    ad = create(:ad, user: create(:user), published_at: 6.days.ago)
    original_path = ads_woeid_path(ad.woeid_code, type: 'give')
    post ads_bump_path(ad), headers: { 'HTTP_REFERER' => original_path }

    assert_equal 6.days.ago.to_date, ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to original_path
  end

  it 'does not bump ads too recent' do
    visit_ad_page(create(:ad, user: @current_user, published_at: 4.days.ago))

    assert_no_selector 'a', text: 'Republicar'
  end

  it 'does not bump ads too recent (direct request)' do
    ad = create(:ad, user: @current_user, published_at: 4.days.ago)
    original_path = ads_woeid_path(ad.woeid_code, type: 'give')
    post ads_bump_path(ad), headers: { 'HTTP_REFERER' => original_path }

    assert_equal 4.days.ago.to_date, ad.reload.published_at.to_date
    assert_response :redirect
    assert_redirected_to original_path
  end

  it 'changes ad status' do
    visit_ad_page(create(:ad, :available, user: @current_user))

    assert_no_selector 'a', text: 'Marcar disponible'
    assert_selector 'a', text: 'Marcar reservado'
    assert_selector 'a', text: 'Marcar entregado'

    click_link 'Marcar reservado'

    assert_text 'Anuncio reservado'
    assert_selector 'a', text: 'Marcar disponible'
    assert_no_selector 'a', text: 'Marcar reservado'
    assert_selector 'a', text: 'Marcar entregado'
  end

  it 'saves spam ads but does not list them' do
    assert_difference(-> { Ad.count }, 1) do
      submit_ad_form(title: 'Regalo de campista')
    end

    visit root_path
    assert_no_text 'Regalo de campista'
  end

  it 'automatically kicks out spammers' do
    submit_ad_form(title: 'Regalo de campista')

    assert_text 'Tu cuenta aún no ha sido activada'
  end

  private

  def click_link_by_label(text)
    find('a', text: text).click
  end

  def submit_ad_form(file_path: nil, title: 'File')
    visit new_ad_path
    attach_file(:image, file_path) if file_path
    choose 'Un regalo'
    fill_in 'Título de tu anuncio:', with: title
    fill_in 'Cuerpo del anuncio', with: 'My gift is a file full of equis'
    click_button 'Publicar anuncio'
  end

  def with_file_of_size(size)
    Tempfile.create('foo') do |f|
      (size / 2**20).times { f.write('x' * 2**20) }
      f.close

      yield(f.path)
    end
  end
end
