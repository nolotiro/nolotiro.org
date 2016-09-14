# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/web_mocking'

class FriendshipsTest < AuthenticatedTest
  before { @friend = create(:user, username: 'other') }

  it "creates friendships from target user's profile" do
    visit profile_path(@friend.username)
    click_link 'agregar other a tu lista de amigos'

    assert_selector 'a', text: 'eliminar other de tu lista de amigos'
    assert_no_selector 'a', text: 'agregar other a tu lista de amigos'
    assert_text 'Amigo agregado'
  end

  it "destroys friendships from target user's profile" do
    create(:friendship, user: @current_user, friend: @friend)
    visit profile_path(@friend.username)
    click_link 'eliminar other de tu lista de amigos'

    assert_no_selector 'a', text: 'eliminar other de tu lista de amigos'
    assert_selector 'a', text: 'agregar other a tu lista de amigos'
    assert_text 'Amigo eliminado'
  end
end
