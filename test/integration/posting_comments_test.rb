# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class PostingCommentsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include WebMocking

  before { @ad = create(:ad, comments_enabled: true) }

  test 'users need to login before posting a comment' do
    mocking_yahoo_woeid_info(@ad.woeid_code) { visit ad_path(@ad) }

    refute_selector '.ad_comments > form'
  end

  test 'comments can be posted by logged in users' do
    login_as @ad.user
    mocking_yahoo_woeid_info(@ad.woeid_code) { visit ad_path(@ad) }
    fill_in 'Tu comentario', with: 'No tiene ruedas'
    click_button 'Enviar'

    assert_selector '.ad_comment', text: 'No tiene ruedas'
    logout
  end

  test 'comments from spammers are not listed' do
    comment = create(:comment, ad: @ad, body: 'Tiene ruedas?')
    comment.user.ban!
    mocking_yahoo_woeid_info(@ad.woeid_code) { visit ad_path(@ad) }

    assert_no_selector '.ad_comment', text: 'Tiene ruedas?'
  end
end
