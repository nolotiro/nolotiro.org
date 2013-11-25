require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  test "contact requires message" do
    c = Contact.new
    c.valid?
    assert c.errors[:message].include?("no puede estar en blanco")
  end

  test "contact requires email" do
    c = Contact.new
    c.valid?
    assert c.errors[:message].include?("no puede estar en blanco")
  end

  test "contact validates email" do
    c = Contact.new :email => "bla", :message => "yeeeaaa"
    c.valid?
    assert c.errors[:email].include?("no es válido")
  end

  test "contact send mail" do
    c = Contact.new :email => "bla@bla.com", :message => "yeaaahhh"
    assert c.valid?
  end

end
