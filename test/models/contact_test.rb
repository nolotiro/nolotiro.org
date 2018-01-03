# frozen_string_literal: true

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  it 'requires message' do
    c = Contact.new
    c.valid?
    assert_includes c.errors[:message], I18n.t('errors.messages.blank')
  end

  it 'requires email' do
    c = Contact.new
    c.valid?
    assert_includes c.errors[:message], I18n.t('errors.messages.blank')
  end

  it 'validates email' do
    c = Contact.new email: 'bla', message: 'yeeeaaa'
    c.valid?
    assert_includes c.errors[:email], I18n.t('errors.messages.invalid')
  end

  it 'sends mail' do
    c = Contact.new email: 'bla@bla.com', message: 'yyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhhyeaaahhh'
    assert c.valid?
  end
end
