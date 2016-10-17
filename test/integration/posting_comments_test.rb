# frozen_string_literal: true

require 'test_helper'
require 'support/ads'

class PostingCommentsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AdTestHelpers

  before { @ad = create(:ad, comments_enabled: true) }

  test 'users need to login before posting a comment' do
    visit_ad_page(@ad)

    refute_selector '.comments > form'
  end

  test 'comments can be posted by logged in users' do
    login_as @ad.user
    visit_ad_page(@ad)
    fill_in 'Tu comentario', with: 'No tiene ruedas'
    click_button 'Enviar'

    assert_selector '.comment', text: 'No tiene ruedas'
    logout
  end

  test 'comments from spammers are not listed' do
    comment = create(:comment, ad: @ad, body: 'Tiene ruedas?')
    comment.user.ban!
    visit_ad_page(@ad)

    assert_no_selector '.comment', text: 'Tiene ruedas?'
  end

  test 'comments are displayed oldest to newest' do
    create(:comment, ad: @ad, body: 'Araña?', created_at: 12.days.ago)
    create(:comment, ad: @ad, body: 'No, gato', created_at: 1.minute.ago)
    visit_ad_page(@ad)

    assert_selector '.comments h5:first-of-type', text: 'Comentarios'
    assert_selector '.comments div:first-of-type', text: 'Araña?'
    assert_selector '.comments div:nth-of-type(2)', text: 'No, gato'
  end
end
