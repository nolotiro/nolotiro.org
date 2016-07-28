# frozen_string_literal: true
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, 'email' => 'jaimito@gmail.com', 'username' => 'jaimito')
    @admin = FactoryGirl.create(:admin)
  end

  test 'has unique usernames' do
    user1 = FactoryGirl.build(:user, username: 'Username')
    assert user1.valid?
    assert user1.save

    user2 = FactoryGirl.build(:user, username: 'Username')
    assert_not user2.valid?
    assert_not user2.save
    assert_includes user2.errors[:username], 'ya está en uso'
  end

  test 'has unique case insensitive usernames' do
    user1 = FactoryGirl.build(:user, username: 'Username')
    assert user1.valid?
    assert user1.save

    user2 = FactoryGirl.build(:user, username: 'username')
    assert_not user2.valid?
    assert_not user2.save
    assert_includes user2.errors[:username], 'ya está en uso'
  end

  test 'has unique emails' do
    user1 = FactoryGirl.build(:user, email: 'larryfoster@example.com')
    assert user1.valid?
    assert user1.save

    user2 = FactoryGirl.build(:user, email: 'larryfoster@example.com')
    assert_not user2.valid?
    assert_not user2.save
    assert_includes user2.errors[:email], 'ya está en uso'
  end

  test 'saves downcased emails' do
    user1 = FactoryGirl.build(:user, email: 'Larryfoster@example.com')
    assert user1.valid?
    assert user1.save
    assert_equal 'larryfoster@example.com', user1.email
  end

  test 'has passwords no shorter than 5 characters' do
    @user.password = '1234'
    assert_not @user.valid?
    assert_includes @user.errors[:password],
                    'es demasiado corto (5 caracteres mínimo)'

    @user.password = '12345'
    assert @user.valid?
  end

  test 'has non-empty usernames' do
    @user.username = ''
    assert_not @user.valid?
    assert_includes @user.errors[:username], 'no puede estar en blanco'
  end

  test 'has usernames no longer than 63 characters' do
    @user.username = 'A' * 63
    assert @user.valid?

    @user.username = 'A' * 64
    assert_not @user.valid?
    assert_includes @user.errors[:username],
                    'es demasiado largo (63 caracteres máximo)'
  end

  test 'roles work' do
    assert_equal @user.admin?, false
    assert_equal @admin.admin?, true
  end

  test 'default langs work' do
    @user.lang = nil
    @user.save
    assert_equal @user.lang, 'es'
  end

  test 'locking works' do
    @user.lock!
    assert_equal @user.locked?, true
  end

  test 'unlocking works' do
    @user.locked = 1
    @user.save
    @user.unlock!
    assert_equal @user.locked?, false
  end

  test 'requires confirmation for new users' do
    user = FactoryGirl.create(:non_confirmed_user)
    assert_equal(user.active_for_authentication?, false)
  end

  test 'associated ads are deleted when user is deleted' do
    FactoryGirl.create(:ad, user: @user)

    assert_difference(-> { Ad.count }, -1) { @user.destroy }
  end

  test 'associated comments are deleted when user is deleted' do
    FactoryGirl.create(:comment, user: @user)

    assert_difference(-> { Comment.count }, -1) { @user.destroy }
  end
end

class UserScopesTest < ActiveSupport::TestCase
  setup do
    3.times { FactoryGirl.create(:ad, user: user1) }
    2.times { FactoryGirl.create(:ad, user: user2) }
  end

  test 'top overall ignores wanted ads from counts and results' do
    FactoryGirl.create(:ad, user: user3, type: 2)
    user2.ads.last.update(type: 2)

    results = User.top_overall

    assert_equal(2, results.length)
    assert_count(results.first, user1.id, user1.username, 3)
    assert_count(results.second, user2.id, user2.username, 1)
  end

  test 'top overall gives all time top ad publishers' do
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

  test 'top last week accepts argument with number of publishers requested' do
    results = User.top_last_week(1)

    assert_equal(1, results.length)
    assert_count(results.first, user1.id, user1.username, 3)
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
