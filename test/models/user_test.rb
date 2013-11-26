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

end
