# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'

class AdEditionAndRemovalTest < AuthenticatedTest
  include Warden::Test::Helpers

  before do
    @ad = create(:ad, user: @current_user, woeid_code: @current_user.woeid)
  end

  it 'shows an recomendation before deleting ads' do
    visit ads_edit_path(@ad)

    assert_text(
      /te recomendamos que en lugar de borrarlo lo marques como entregado/
    )
  end

  it 'does not update ads from index' do
    visit ads_woeid_path(@current_user.woeid, type: 'give')

    assert_no_selector 'a', text: 'Edita este anuncio'
  end

  it 'properly updates ads from show page and redirects back' do
    initial_path = adslug_path(@ad, slug: @ad.slug)

    assert_update_ad_from(initial_path)
    assert_equal initial_path, current_path
  end

  it 'properly deletes ads from show page and redirects to user list' do
    initial_path = adslug_path(@ad, slug: @ad.slug)

    assert_destroy_ad_from(initial_path)
    assert_equal listads_user_path(@current_user), current_path
  end

  it 'properly deletes ads as an admin and redirects to user list' do
    initial_path = adslug_path(@ad, slug: @ad.slug)

    logout
    login_as create(:admin)

    assert_destroy_ad_from(initial_path)
    assert_equal listads_user_path(@ad.user), current_path
  end

  private

  def assert_destroy_ad_from(path)
    visit path
    click_link 'Edita este anuncio'
    assert_difference('Ad.count', -1) { click_button 'Borrar anuncio' }

    assert_text 'Anuncio borrado'
  end

  def assert_update_ad_from(path)
    visit path
    click_link 'Edita este anuncio'
    click_button 'Actualizar anuncio'

    assert_text 'Anuncio actualizado'
    assert_equal path, current_path
  end
end
