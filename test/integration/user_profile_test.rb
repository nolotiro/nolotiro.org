# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class UserProfileTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks
  include WebMocking

  around do |&block|
    @user = create(:user, email: 'jaimito@example.com', username: 'jaimito')
    @ad = create(:ad, user: @user)

    mocking_yahoo_woeid_info(@ad.woeid_code) { block.call }
  end

  it 'gets user profile by username' do
    visit profile_path(@user.username)

    assert_text 'Nombre de usuario: jaimito'
  end

  it 'gets user profile by username, even when it has dots in it' do
    @user.update!(username: 'A.n.')
    visit profile_path(@user.username)

    assert_text 'Nombre de usuario: A.n.'
  end

  it 'gets user profile by id' do
    visit profile_path(@user.id)

    assert_text 'Nombre de usuario: jaimito'
  end

  it 'shows user ad list in profile' do
    visit profile_path(@user.username)

    assert_text @ad.body
  end

  it 'gives 404 for profiles of banned users' do
    @user.ban!

    assert_raises(ActiveRecord::RecordNotFound) do
      visit profile_path(@user.username)
    end
  end
end
