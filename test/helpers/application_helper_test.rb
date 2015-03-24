require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "should get_location_options" do
    result = get_location_options 766273
    expected_result = [["Madrid, Madrid, España (1 anuncios)", 766273], ["Madrid, Cundinamarca, Colombia (0 anuncios)", 361938], ["Madrid, Virginia, Estados Unidos (0 anuncios)", 2444047], ["Madrid, Colima, México (0 anuncios)", 132644], ["Madrid, Nueva York, Estados Unidos (0 anuncios)", 2444049], ["Madrid, Nuevo México, Estados Unidos (0 anuncios)", 2444048], ["Madrid, Iowa, Estados Unidos (0 anuncios)", 2444050], ["Madrid, Nebraska, Estados Unidos (0 anuncios)", 2444046], ["Madrid, Kentucky, Estados Unidos (0 anuncios)", 2444044], ["Madrid, Territorio de Alabama, Estados Unidos (0 anuncios)", 2444051], ["Madrid, Caraga, Filipinas (0 anuncios)", 1199420], ["Madrid, Maine, Estados Unidos (0 anuncios)", 2444045], ["Madrid, Östergötland, Suecia (0 anuncios)", 897980], ["Madrid, Andalucía, España (0 anuncios)", 90234640], ["Madrid, Colorado, Estados Unidos (0 anuncios)", 55959908], ["Madrid, Saskatchewan, Canadá (0 anuncios)", 23403504], ["Madrid, Isla de Francia, Francia (0 anuncios)", 90794566], ["Madrid, Murcia, España (0 anuncios)", 90268074], ["Madrid, Murcia, España (0 anuncios)", 90266634], ["Madrid, Andalucía, España (0 anuncios)", 90262795], ["Madrid, Coahuila de Zaragoza, México (0 anuncios)", 90289822]]
    assert_equal expected_result, result

    result = get_location_options 716271
    expected_result = [["Gordale, Liguria, Italia (0 anuncios)", 716271]]
    assert_equal expected_result, result
  end

  test "should cache_key_for" do
    result1 = cache_key_for "123", User.new
    result2 = cache_key_for "123", User.new
    assert_equal result1, result2
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result1
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result2

    result3 = cache_key_for "123", FactoryGirl.create(:user)
    result4 = cache_key_for "123", FactoryGirl.create(:admin)
    assert_not_equal result3, result4
    assert_equal "f97ead06c958e1e778e65e99d7de7f67", result3
    assert_equal "38ed13109ed92bc1eb89b82c8345ed01", result4
  end

  test "should i18n_to_localeapp_in_locale" do
    assert_equal 20647, i18n_to_localeapp_in_locale(:en)
    assert_equal 24068, i18n_to_localeapp_in_locale(:nl)
    assert_equal 20645, i18n_to_localeapp_in_locale(:de)
    assert_equal 20649, i18n_to_localeapp_in_locale(:it)
  end

end
