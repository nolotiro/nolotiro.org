# frozen_string_literal: true

require 'test_helper'
require 'support/ads'

class PostingCommentsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AdTestHelpers

  before { @ad = create(:ad, comments_enabled: true) }

  it 'needs to login before posting a comment' do
    visit_ad_page(@ad)

    refute_selector '.comments > form'
  end

  it 'allows posting comments only to logged in users' do
    login_as @ad.user
    visit_ad_page(@ad)
    fill_in 'Tu comentario', with: 'No tiene ruedas'
    click_button 'Enviar'

    assert_selector '.comment', text: 'No tiene ruedas'
    logout
  end

  it 'does not list comments from spammers' do
    comment = create(:comment, ad: @ad, body: 'Tiene ruedas?')
    comment.user.ban!
    visit_ad_page(@ad)

    assert_no_selector '.comment', text: 'Tiene ruedas?'
  end

  it 'displays comments oldest to newest' do
    create(:comment, ad: @ad, body: 'Araña?', created_at: 12.days.ago)
    create(:comment, ad: @ad, body: 'No, gato', created_at: 1.minute.ago)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit adslug_path(@ad, slug: @ad.slug)
    end

    assert_selector '.comments h5:first-of-type', text: 'Comentarios'
    assert_selector '.comments div:first-of-type', text: 'Araña?'
    assert_selector '.comments div:nth-of-type(2)', text: 'No, gato'
  end
end
