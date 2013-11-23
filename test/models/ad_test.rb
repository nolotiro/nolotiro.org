require 'test_helper'

class AdTest < ActiveSupport::TestCase

  test "ad requires title" do
    a = Ad.new
    a.valid?
    assert a.errors[:title].include?("can't be blank")
  end

  test "ad requires body" do
    a = Ad.new
    a.valid?
    assert a.errors[:body].include?("can't be blank")
  end

  test "ad requires user_owner" do
    a = Ad.new
    a.valid?
    assert a.errors[:user_owner].include?("can't be blank")
  end

  test "ad requires type" do
    a = Ad.new
    a.valid?
    assert a.errors[:type].include?("can't be blank")
  end

  test "ad requires woeid_code" do
    a = Ad.new
    a.valid?
    assert a.errors[:woeid_code].include?("can't be blank")
  end

  test "ad requires date_created" do
    a = Ad.new
    a.valid?
    assert a.errors[:date_created].include?("can't be blank")
  end

  test "ad requires ip" do
    a = Ad.new
    a.valid?
    assert a.errors[:ip].include?("can't be blank")
  end

  test "ad requires status " do
    a = Ad.new
    a.valid?
    assert a.errors[:status].include?("can't be blank")
  end

  test "ad validates type " do
    # 1 2
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad validates status " do
    # 1 2 3
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad validates ip " do
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad check slug" do
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad check type_string" do
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad check status_string" do
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

  test "ad check status_class" do
    a = Ad.new
    a.valid?
    assert a.errors[:].include?("can't be blank")
    assert false
  end

end

