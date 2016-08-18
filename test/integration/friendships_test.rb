# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class FriendshipsTest < ActionDispatch::IntegrationTest
  include Authentication

  before do
    @user = create(:user)
    @friend = create(:user, username: 'other')

    login_as @user
  end

  it "creates friendships from target user's profile" do
    visit profile_path(@friend)
    click_link 'agregar other a tu lista de amigos'

    assert_link 'eliminar other de tu lista de amigos'
    refute_link 'agregar other a tu lista de amigos'
    assert_text 'Amigo agregado'
  end

  it "destroys friendships from target user's profile" do
    create(:friendship, user: @user, friend: @friend)
    visit profile_path(@friend)
    click_link 'eliminar other de tu lista de amigos'

    refute_link 'eliminar other de tu lista de amigos'
    assert_link 'agregar other a tu lista de amigos'
    assert_text 'Amigo eliminado'
  end
end
