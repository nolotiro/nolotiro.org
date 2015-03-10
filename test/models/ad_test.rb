# encoding : utf-8
class AdTest < ActiveSupport::TestCase

  require 'test_helper'
 
  setup do
    @ad = FactoryGirl.create(:ad)
  end

  test "ad requires everything" do
    a = Ad.new
    a.valid?
    assert a.errors[:status].include?("no puede estar en blanco")
    assert a.errors[:body].include?("no puede estar en blanco")
    assert a.errors[:title].include?("no puede estar en blanco")
    assert a.errors[:user_owner].include?("no puede estar en blanco")
    assert a.errors[:type].include?("no puede estar en blanco")
    assert a.errors[:woeid_code].include?("no puede estar en blanco")
    assert a.errors[:ip].include?("no puede estar en blanco")
  end

  test "ad validates type" do
    # only is allowed "1 2"
    @ad.type = 1
    assert @ad.valid?
    assert_equal @ad.type, 1
    @ad.type = 2
    assert @ad.valid?
    assert_equal @ad.type, 2
    @ad.type = 3
    @ad.valid?
    assert @ad.errors[:type].include?("no es un tipo válido")
  end

  test "ad validates status" do
    # only is allowed "1 2 3"
    @ad.status = 1
    assert @ad.valid?
    assert_equal @ad.status, 1
    @ad.status = 2
    assert @ad.valid?
    assert_equal @ad.status, 2
    @ad.status = 3
    assert @ad.valid?
    assert_equal @ad.status, 3
    @ad.status = 4
    @ad.valid?
    assert @ad.errors[:status].include?("no es un estado válido")
  end

  test "ad validates lenght" do
    @ad.title = "a" * 200
    assert_not @ad.save
    assert @ad.errors[:title].include?("es demasiado largo (100 caracteres máximo)")
  end

  test "ad check slug" do
    assert_equal @ad.slug, "ordenador-en-vallecas"
  end

  test "ad check type_string" do
    assert_equal @ad.type_string, "regalo"
    @ad.type = 2
    @ad.save
    assert_equal @ad.type_string, "busco"
  end

  test "ad check status_string" do
    assert_equal @ad.status_string, "disponible"
    @ad.status = 2
    @ad.save
    assert_equal @ad.status_string, "reservado"
    @ad.status = 3
    @ad.save
    assert_equal @ad.status_string, "entregado"
  end

  test "ad check type_class" do
    assert_equal @ad.type_class, "give"
    @ad.type = 2
    @ad.save
    assert_equal @ad.type_class, "want"
  end

  test "ad check status_class" do
    assert_equal @ad.status_class, "available"
    @ad.status = 2
    @ad.save
    assert_equal @ad.status_class, "booked"
    @ad.status = 3
    @ad.save
    assert_equal @ad.status_class, "delivered"
  end

  test "ad is_give? or is_want?" do
    @ad.type = 1
    @ad.save
    assert_equal @ad.is_give?, true
    @ad.type = 2
    @ad.save
    assert_equal @ad.is_want?, true
  end

  test "ad meta_title" do
    @ad.type = 1
    @ad.save
    assert_equal @ad.meta_title, "regalo segunda mano gratis  ordenador en Vallecas Madrid, Madrid, España"
    @ad.type = 2
    @ad.save
    assert_equal @ad.meta_title, "busco ordenador en Vallecas Madrid, Madrid, España"
  end

#  Disabling IP validation. Some legacy IP are bad (8.8.8.1, 24.2.2.2) 
#  test "ad validates ip address - fail" do
#    @ad.ip = '999.99.9.9'
#    @ad.valid?
#    assert @ad.errors[:ip].include?("No es una IP válida")
#  end
#
#  test "ad validates ip address - success" do
#    @ad.ip = '2.2.2.2'
#    assert @ad.valid?
#  end

end

