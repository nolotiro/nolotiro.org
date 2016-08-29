# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/web_mocking'

class BlockingsTest < AuthenticatedTest
  before do
    @enemy = create(:user, username: 'other')

    visit profile_path(@enemy)
  end

  it "blocks from targe users's profile" do
    visit profile_path(@enemy)
    click_link 'bloquear a other'

    assert_no_selector 'a', text: /\Abloquear a other\z/
    assert_selector 'a', text: 'desbloquear a other'
    assert_text 'Usuario bloqueado'
  end

  it "unblocks from target user's profile" do
    create(:blocking, blocker: @current_user, blocked: @enemy)
    visit profile_path(@enemy)
    click_link 'desbloquear a other'

    assert_no_selector 'a', text: 'desbloquear a other'
    assert_selector 'a', text: /\Abloquear a other\z/
    assert_text 'Usuario desbloqueado'
  end
end
