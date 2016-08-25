# frozen_string_literal: true
require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  before do
    @user = create(:user, email: 'jaimito@gmail.com', username: 'jaimito')
  end

  it 'gets user profile by username' do
    visit profile_path(username: @user.username)

    assert_text 'Perfil de usuario - jaimito'
  end

  it 'gets user profile by id' do
    visit profile_path(username: @user.id)

    assert_text 'Perfil de usuario - jaimito'
  end

  it 'gets user ad list' do
    visit listads_user_path(id: @user.id)

    assert_text 'Anuncios publicados - jaimito'
  end
end
