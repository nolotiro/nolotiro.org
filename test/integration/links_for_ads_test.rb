# frozen_string_literal: true

require "test_helper"
require "support/ads"

class LinksForAds < ActionDispatch::IntegrationTest
  include AdTestHelpers

  it "shows message link in available ads" do
    visit_ad_page_with_type(:available)

    assert_text "Envía un mensaje privado a lisa"
  end

  it "does not show message link in booked ads" do
    visit_ad_page_with_type(:booked)

    assert_no_text "Envía un mensaje privado a lisa"
  end

  it "does not show message link in delivered ads" do
    visit_ad_page_with_type(:delivered)

    assert_no_text "Envía un mensaje privado a lisa"
  end

  it "shows message link in petition ads" do
    visit_ad_page_with_type(:want)

    assert_text "Regálaselo a lisa"
  end

  private

  def visit_ad_page_with_type(type)
    visit_ad_page(create(:ad, type, user: create(:user, username: "lisa")))
  end
end
