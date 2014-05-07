require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  test "should mailboxer messages model work" do
    sender = FactoryGirl.create(:user)
    receiver = FactoryGirl.create(:user)
    receipt = sender.send_message(receiver, 'body', 'subject')
    assert_equal receipt.valid?, true
  end

end
