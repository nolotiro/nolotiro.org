# frozen_string_literal: true

require 'integration/concerns/messaging'

module SelfMessages
  include Warden::Test::Helpers
  include Messaging

  def setup
    super

    @user1 = create(:user, username: 'user1')
    @user2 = create(:user, username: 'user2')

    login_as @user1

    visit new_conversation_path(recipient_id: @user1.id)
  end

  def teardown
    super

    logout
  end

  def test_self_messages_after_a_previous_error
    visit new_conversation_path(recipient_id: @user1.id)
    send_message(body: 'hola, yo')
    send_message(subject: 'forgot the title', body: 'hola, yo')

    assert_message_sent 'hola, yo'
  end
end
