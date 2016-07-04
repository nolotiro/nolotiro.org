require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  before { @old_locale = I18n.locale }

  after { I18n.locale = @old_locale }

  it 'assigns locale from param if available' do
    get root_path(locale: 'pt'), {}, 'HTTP_ACCEPT_LANGUAGE' => 'it'

    assert_equal :pt, I18n.locale
  end

  it 'assigns locale from browser if no param' do
    get root_path(locale: nil), {}, 'HTTP_ACCEPT_LANGUAGE' => 'it'

    assert_equal :it, I18n.locale
  end

  it 'falls back to default locale if no param or browser locale' do
    get root_path(locale: nil)

    assert_equal I18n.default_locale, I18n.locale
  end
end
