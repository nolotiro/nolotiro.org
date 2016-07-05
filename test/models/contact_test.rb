# frozen_string_literal: true
require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  test 'contact requires message' do
    c = Contact.new
    c.valid?
    assert_includes c.errors[:message], I18n.t('errors.messages.blank')
  end

  test 'contact requires email' do
    c = Contact.new
    c.valid?
    assert_includes c.errors[:message], I18n.t('errors.messages.blank')
  end

  test 'contact validates email' do
    c = Contact.new :email => 'bla', :message => 'yeeeaaa'
    c.valid?
    assert_includes c.errors[:email], I18n.t('errors.messages.invalid')
  end

  test 'contact send mail' do
    c = Contact.new :email => 'bla@bla.com', :message => 'yyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhheaaahhh'
    assert c.valid?
  end

end
