# frozen_string_literal: true

require 'test_helper'

class ContactingUsTest < ActionDispatch::IntegrationTest
  before do
    visit root_path
    click_link 'contacto'
  end

  it 'shows the new contact form' do
    assert_text 'Formulario de contacto'
  end

  it 'shows errors in form' do
    submit_contact_form(email: 'hola@mundo.com', body: 'hola mundo.')

    assert_equal contacts_path, current_path
    assert_text 'demasiado corto'
  end

  it 'verifies recaptcha in contact form' do
    submit_contact_form(email: 'hola@mundo.com', body: 'hola mundo. hola mundo. hola mundo. hola mundo.')

    assert_equal root_path, current_path
    assert_text I18n.t('nlt.contact_thanks')
  end

  private

  def submit_contact_form(email:, body:)
    fill_in 'Correo electrónico', with: email
    fill_in 'Mensaje', with: body
    click_button 'Enviar'
  end
end
