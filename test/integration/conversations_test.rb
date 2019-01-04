# frozen_string_literal: true

require "test_helper"
require "integration/concerns/messaging"

class ConversationsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include Messaging

  def setup
    super

    user1 = create(:user, username: "user1")
    user2 = create(:user, username: "user2")

    login_as user1

    visit new_conversation_path(recipient_id: user2.id)
  end

  def teardown
    super

    logout
  end

  def test_shows_errors_when_replying_to_conversation_with_empty_message
    send_message(subject: "hola, user2", body: "How you doing?")
    send_message(body: "")

    assert_text "Mensaje no puede estar en blanco"
  end
end
