# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/ads'
require 'support/web_mocking'

class AdManagementTest < AuthenticatedTest
  include AdTestHelpers
  include WebMocking

  it 'can have pictures of 5 megabytes or less' do
    with_file_of_size(5.megabytes) do |path|
      mocking_yahoo_woeid_info(@current_user.woeid) do
        submit_ad_form(file_path: path)

        assert_no_text('Imagen debe estar entre 0 Bytes y 5 MB')
      end
    end
  end

  it 'cannot have pictures bigger than 5 megabytes' do
    with_file_of_size(6.megabytes) do |path|
      mocking_yahoo_woeid_info(@current_user.woeid) do
        submit_ad_form(file_path: path)

        assert_text('Imagen debe estar entre 0 Bytes y 5 MB')
      end
    end
  end

  it 'republishes ads' do
    visit_ad_page(create(:ad, user: @current_user, published_at: 6.days.ago))
    click_link 'Republica este anuncio'

    assert_text 'Anuncio republicado'
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
    mocking_yahoo_woeid_info(@current_user.woeid) do
      assert_difference(-> { Ad.count }, 1) do
        submit_ad_form(title: 'Regalo de campista')
      end
    end

    visit root_path
    assert_no_text 'Regalo de campista'
  end

  it 'automatically kicks out spammers' do
    mocking_yahoo_woeid_info(@current_user.woeid) do
      submit_ad_form(title: 'Regalo de campista')
    end

    assert_text 'Tu cuenta aún no ha sido activada'
  end

  private

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
