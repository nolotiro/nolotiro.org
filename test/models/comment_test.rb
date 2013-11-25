require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "comment requires ads_id" do
    c = Comment.new
    c.valid?
    assert c.errors[:ads_id].include?("no puede estar en blanco")
  end

  test "comment requires body" do
    c = Comment.new
    c.valid?
    assert c.errors[:body].include?("no puede estar en blanco")
  end

  test "comment requires date_created" do
    c = Comment.new
    c.valid?
    assert c.errors[:date_created].include?("no puede estar en blanco")
  end

  test "comment requires user_owner" do
    c = Comment.new
    c.valid?
    assert c.errors[:user_owner].include?("no puede estar en blanco")
  end

  test "comment requires ip" do
    c = Comment.new
    c.valid?
    assert c.errors[:ip].include?("no puede estar en blanco")
  end

end
