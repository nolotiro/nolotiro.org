# frozen_string_literal: true

require "test_helper"
require "integration/concerns/authenticated_test"
require "support/ads"

class BanningTest < AuthenticatedTest
  include AdTestHelpers

  it "automatically kicks out banned users" do
    mocking_yahoo_woeid_info(@current_user.woeid) do
      visit root_path
      assert_selector "#header", text: @current_user.username

      @current_user.ban!

      visit root_path
      assert_selector "#header", text: "acceder"
      assert_text "Tu cuenta aún no ha sido activada"
    end
  end

  it "hides ads from banned users" do
    ad = create(:ad)
    ad.user.ban!
    visit_ad_page(ad)

    assert_no_text ad.body
  end
end
