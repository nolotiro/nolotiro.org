# frozen_string_literal: true

require 'test_helper'

class LocaleTest < ActionDispatch::IntegrationTest
  before { @old_locale = I18n.locale }

  after { I18n.locale = @old_locale }

  it 'switches locale properly' do
    visit root_path(locale: 'pt')
    click_link 'Italiano'

    assert_equal :it, I18n.locale
  end

  it 'assigns locale from param if available' do
    get root_path(locale: 'pt')

    assert_equal :pt, I18n.locale
  end

  it 'assigns locale from session if no locale param' do
    visit root_path(locale: 'pt')
    click_link 'Italiano'
    visit root_path(locale: nil)

    assert_equal :it, I18n.locale
  end

  it 'ignores deprecated cookies in session' do
    get root_path(locale: nil), {}, 'HTTP_COOKIE' => 'locale=eu;'

    assert_equal I18n.default_locale, I18n.locale
  end

  it 'ignores trying to set deprecated locales' do
    assert_raise(ActionController::RoutingError) do
      visit '/locales/eu'
    end
  end

  it 'assigns locale from browser if no locale in param or session' do
    get root_path(locale: nil), {}, 'HTTP_ACCEPT_LANGUAGE' => 'it'

    assert_equal :it, I18n.locale
  end

  it 'falls back to default locale if no locale in param, session or browser' do
    get root_path(locale: nil)

    assert_equal I18n.default_locale, I18n.locale
  end
end
