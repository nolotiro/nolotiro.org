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

class UserScopesTest < ActiveSupport::TestCase
  setup do
    3.times { FactoryGirl.create(:ad, user: user1) }
    2.times { FactoryGirl.create(:ad, user: user2) }
  end

  test "top overall gives all time top ad publishers" do
    FactoryGirl.create(:ad, user: user3)

    results = User.top_overall

    assert_equal(3, results.length)

    assert_count(results.first, user1.id, user1.username, 3)
    assert_count(results.second, user2.id, user2.username, 2)
    assert_count(results.third, user3.id, user3.username, 1)
  end

  test "top last week gives last week's top publishers" do
    FactoryGirl.create(:ad, user: user3, published_at: 8.days.ago)

    results = User.top_last_week

    assert_equal(2, results.length)
    assert_count(results.first, user1.id, user1.username, 3)
    assert_count(results.second, user2.id, user2.username, 2)
  end

  private

  def assert_count(user, id, username, n_ads)
    assert_equal id, user.id
    assert_equal username, user.username
    assert_equal n_ads, user.n_ads
  end

  def user1
    @user1 ||= FactoryGirl.create(:user, username: 'user1')
  end

  def user2
    @user2 ||= FactoryGirl.create(:user, username: 'user2')
  end

  def user3
    @user3 ||= FactoryGirl.create(:user, username: 'user3')
  end
end
