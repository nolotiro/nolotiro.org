# frozen_string_literal: true

require "test_helper"
require "integration/concerns/authenticated_test"

class BlockingsTest < AuthenticatedTest
  before { @enemy = create(:user) }

  it "blocks from targe users's profile" do
    visit profile_path(@enemy.username)
    click_link "bloquear"

    assert_no_selector "a", text: /\Abloquear\z/
    assert_link "desbloquear"
    assert_text "Usuario bloqueado"
  end

  it "unblocks from target user's profile" do
    create(:blocking, blocker: @current_user, blocked: @enemy)
    visit profile_path(@enemy.username)
    click_link "desbloquear"

    assert_no_link "desbloquear"
    assert_selector "a", text: /\Abloquear\z/
    assert_text "Usuario desbloqueado"
  end
end
