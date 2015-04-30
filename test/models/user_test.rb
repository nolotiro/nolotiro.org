require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
    @admin = FactoryGirl.create(:admin)
  end

  test "should uniqueness validation on username work" do 
    user1 = FactoryGirl.build(:user, username: "Username") 
    assert user1.valid?
    assert user1.save

    user2 = FactoryGirl.build(:user, username: "Username") 
    assert_not user2.valid?
    assert_not user2.save
    assert user2.errors[:username].include? "ya está en uso"
  end

  test "should uniqueness validation on email work" do 
    user1 = FactoryGirl.build(:user, email: "larryfoster@example.com") 
    assert user1.valid?
    assert user1.save

    user2 = FactoryGirl.build(:user, email: "larryfoster@example.com") 
    assert_not user2.valid?
    assert_not user2.save
    assert user2.errors[:email].include? "ya está en uso"
  end

  test "shouldn't let a password with 4 characters - minimal 5" do 
    @user.password = "1234"
    @user.password = "1234"
    assert_not @user.valid?
    assert @user.errors[:password].include? "es demasiado corto (5 caracteres mínimo)"
  end

  test "should let a password with 5 characters" do 
    @user.password = "12345"
    @user.password = "12345"
    assert @user.valid?
  end

  test "shouldn't let a username with 2 characters - minimal 3" do 
    @user.username = "12"
    assert_not @user.valid?
    assert @user.errors[:username].include? "es demasiado corto (3 caracteres mínimo)"
  end

  test "should let a username with 3 characters" do 
    @user.username = "123"
    assert @user.valid?
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

  test "should need confirmation for a new user" do
    user = FactoryGirl.create(:non_confirmed_user)
    assert_equal(user.active_for_authentication?, false)
  end

end
