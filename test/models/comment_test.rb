# frozen_string_literal: true

require "test_helper"

class CommentTest < ActiveSupport::TestCase
  it "requires everything" do
    c = Comment.new
    c.valid?

    assert c.errors[:ads_id].include?("no puede estar en blanco")
    assert c.errors[:body].include?("no puede estar en blanco")
    assert c.errors[:user_owner].include?("no puede estar en blanco")
    assert c.errors[:ip].include?("no puede estar en blanco")
  end

  it "escapes privacy data in the title" do
    text = "contactar por email example@example.com, o whatsapp al 666666666"

    expected_text = <<-TXT.squish
      contactar por email [INFORMACIÓN PRIVADA OCULTA], o [INFORMACIÓN PRIVADA
      OCULTA] al [INFORMACIÓN PRIVADA OCULTA]
    TXT

    comment = build(:comment, body: text)

    assert_equal expected_text, comment.filtered_body
  end
end
