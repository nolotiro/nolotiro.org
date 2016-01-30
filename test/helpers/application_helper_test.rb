require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "should escape_privacy_data" do 
    text = "si hay interés, por favor, contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666"
    expected_text = "si hay interés, por favor, contactar por email  , por sms  , o   al  "
    assert_equal(escape_privacy_data(text), expected_text)
  end

  test "should get_location_options" do
    skip
  #  result = get_location_options 766275
  #  expected_result = [["7662, Transisalania, Países Bajos (0 anuncios)", 12852904], ["766, Orissa, India (0 anuncios)", 24551724], ["76, Región Noroeste de Singapur, Singapur (0 anuncios)", 24703068]]
  #  assert_equal expected_result, result

  #  result = get_location_options 716271
  #  expected_result = [["Gordale, Liguria, Italia (0 anuncios)", 716271]]
  #  assert_equal expected_result, result
  end

  test "should i18n_to_localeapp_in_locale, :en" do
    assert_equal 20647, i18n_to_localeapp_in_locale(:en)
  end

  test "should i18n_to_localeapp_in_locale, :nl" do
    assert_equal 24068, i18n_to_localeapp_in_locale(:nl)
  end

  test "should i18n_to_localeapp_in_locale, :de" do
    assert_equal 20645, i18n_to_localeapp_in_locale(:de)
  end

  test "should i18n_to_localeapp_in_locale, :it" do
    assert_equal 20649, i18n_to_localeapp_in_locale(:it)
  end
end
