# encoding : utf-8

class AdTest < ActiveSupport::TestCase

  require 'test_helper'

  setup do
    @ad = FactoryGirl.create(:ad, woeid_code: 455825)
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

  test "ad validates maximum length of title" do
    @ad.title = "a" * 200
    assert_not @ad.save
    assert @ad.errors[:title].include?("es demasiado largo (100 caracteres máximo)")
  end

  test "ad validates minimum length of title" do
    assert_not @ad.update(title: "a" * 3)
    assert @ad.errors[:title].include?("es demasiado corto (4 caracteres mínimo)")
  end

  test "ad escaped title and body with escape_privacy_data" do 
    text = "contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666"
    expected_text = "contactar por email  , por sms  , o   al  "
    @ad.update_attribute(:body, text)
    @ad.update_attribute(:title, text)
    assert_equal(@ad.body, expected_text)
    assert_equal(@ad.title, expected_text)
  end

  test "ad validates length of body" do
    assert_not @ad.update(body: "a" * 1001)
    assert @ad.errors[:body].include?("es demasiado largo (1000 caracteres máximo)")
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

  test "ad meta_title for give ads" do
    @ad.type = 1
    @ad.save
    title = "regalo segunda mano gratis  ordenador en Vallecas Río de Janeiro, Rio de Janeiro, Brasil"
    assert_equal title, @ad.meta_title
  end

  test "ad meta_title for want ads" do
    skip
    @ad.type = 2
    @ad.save
    title = "busco ordenador en Vallecas Río de Janeiro, Rio de Janeiro, Brasil"
    assert_equal title, @ad.meta_title
  end

  test "ad body shoudl store emoji" do 
    skip
    body = 'What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!'
    @ad.body = body
    @ad.save 
    assert_equal @ad.body, body
  end

  test "ad bumping refreshes publication date" do
    @ad.published_at = 1.week.ago
    @ad.bump

    assert_in_delta Time.zone.now.to_i, @ad.published_at.to_i, 1
  end

  test "ad bumping resets readed count" do
    @ad.readed_count = 100
    @ad.bump

    assert_equal 0, @ad.readed_count
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

