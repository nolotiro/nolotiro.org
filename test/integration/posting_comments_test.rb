# frozen_string_literal: true
require 'test_helper'
require 'integration/concerns/authentication'
require 'support/web_mocking'

class PostingCommentsTest < ActionDispatch::IntegrationTest
  include Authentication
  include WebMocking

  before { @ad = FactoryGirl.create(:ad, comments_enabled: true) }

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
  end
end
