# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class BlockingsTest < ActionDispatch::IntegrationTest
  include Authentication

  before do
    @user = create(:user)
    @enemy = create(:user, username: 'other')

    login_as @user
    visit profile_path(@enemy)
  end

  it "blocks from targe users's profile" do
    visit profile_path(@enemy)
    click_link 'bloquear a other'

    refute_link 'bloquear a other'
    assert_link 'desbloquear a other'
    assert_text 'Usuario bloqueado'
  end

  it "unblocks from target user's profile" do
    create(:blocking, blocker: @user, blocked: @enemy)
    visit profile_path(@enemy)
    click_link 'desbloquear a other'

    refute_link 'desbloquear a other'
    assert_link 'bloquear a other'
    assert_text 'Usuario desbloqueado'
  end
end
