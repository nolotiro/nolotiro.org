require 'test_helper'

class LocaleTest < ActionDispatch::IntegrationTest
  before { @old_locale = I18n.locale }

  after { I18n.locale = @old_locale }

  it 'assigns locale from param if available' do
    get root_path(locale: 'pt'), {}, 'HTTP_ACCEPT_LANGUAGE' => 'it'

    assert_equal :pt, I18n.locale
  end

  it 'assigns locale from browser if no locale param' do
    get root_path(locale: nil), {}, 'HTTP_ACCEPT_LANGUAGE' => 'it'

    assert_equal :it, I18n.locale
  end

  it 'falls back to default locale if no locale in param or browser' do
    get root_path(locale: nil)

    assert_equal I18n.default_locale, I18n.locale
  end
end
