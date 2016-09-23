# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/web_mocking'

class BanningTest < AuthenticatedTest
  include WebMocking

  it 'automatically kicks out banned users' do
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit root_path
      assert_selector '#header', text: @current_user.name

      @current_user.ban!

      visit root_path
      assert_selector '#header', text: 'acceder'
      assert_text 'Tu cuenta aún no ha sido activada'
    end
  end

  it 'hides ads from banned users' do
    ad = create(:ad)
    ad.user.ban!
    mocking_yahoo_woeid_info(ad.woeid_code) { visit ad_path(ad) }

    assert_no_text ad.body
  end
end
