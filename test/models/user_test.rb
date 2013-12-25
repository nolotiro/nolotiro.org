require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
    @admin = FactoryGirl.create(:admin)
  end

  test "should roles work" do 
    assert_equal @user.admin?, false
    assert_equal @admin.admin?, true
  end

  test "should default lang work" do
    @user.lang = nil
    @user.save
    assert_equal @user.lang, 'es'
  end

  test "should lock! an user" do
    @user.lock!
    assert_equal @user.locked?, true
  end

  test "should unlock! an user" do
    @user.locked = 1
    @user.save
    @user.unlock!
    assert_equal @user.locked?, false
  end

end
