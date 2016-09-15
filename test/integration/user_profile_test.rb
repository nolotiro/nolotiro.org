# frozen_string_literal: true

require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  before do
    @user = create(:user, email: 'jaimito@example.com', username: 'jaimito')
  end

  it 'gets user profile by username' do
    visit profile_path(@user.username)

    assert_text 'Perfil de usuario - jaimito'
  end

  it 'gets user profile by id' do
    visit profile_path(@user.id)

    assert_text 'Perfil de usuario - jaimito'
  end

  it 'gets user ad list by username' do
    visit listads_user_path(@user.username)

    assert_text 'Anuncios publicados - jaimito'
  end

  it 'gets user ad list by id' do
    visit listads_user_path(@user.id)

    assert_text 'Anuncios publicados - jaimito'
  end

  it 'gives 404 for profiles of locked users' do
    @user.lock!

    assert_raises(ActiveRecord::RecordNotFound) do
      visit profile_path(@user.username)
    end
  end

  it 'gives 404 for ad list of locked users' do
    @user.lock!

    assert_raises(ActiveRecord::RecordNotFound) do
      visit listads_user_path(@user.id)
    end
  end
end
