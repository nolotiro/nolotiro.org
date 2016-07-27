# frozen_string_literal: true
require 'integration/concerns/messaging'

module SelfMessages
  include Warden::Test::Helpers
  include Messaging

  def setup
    super

    @user1 = FactoryGirl.create(:user, username: 'user1')
    @user2 = FactoryGirl.create(:user, username: 'user2')

    login_as @user1

    visit message_new_path(@user1)
  end

  def test_self_messages_after_a_previous_error
    visit message_new_path(@user1)
    send_message(body: 'hola, yo')
    send_message(subject: 'forgot the title', body: 'hola, yo')

    assert_message_sent 'hola, yo'
  end
end
