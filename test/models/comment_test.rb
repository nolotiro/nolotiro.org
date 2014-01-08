require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "comment requires everything" do
    c = Comment.new
    c.valid?
    assert c.errors[:ads_id].include?("no puede estar en blanco")
    assert c.errors[:body].include?("no puede estar en blanco")
    assert c.errors[:user_owner].include?("no puede estar en blanco")
    assert c.errors[:ip].include?("no puede estar en blanco")
  end

end
