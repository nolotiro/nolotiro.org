require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  test "contact requires message" do
    c = Contact.new
    c.valid?
    assert c.errors[:message].include?(I18n.t('activerecord.errors.messages.blank'))
  end

  test "contact requires email" do
    c = Contact.new
    c.valid?
    assert c.errors[:message].include?(I18n.t('activerecord.errors.messages.blank'))
  end

  test "contact validates email" do
    c = Contact.new :email => "bla", :message => "yeeeaaa"
    c.valid?
    assert c.errors[:email].include?(I18n.t('activerecord.errors.messages.invalid'))
  end

  test "contact send mail" do
    c = Contact.new :email => "bla@bla.com", :message => "yyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhheaaahhh"
    assert c.valid?
  end

end
