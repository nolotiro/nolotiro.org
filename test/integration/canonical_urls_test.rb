# frozen_string_literal: true

require "test_helper"

class CanonicalUrlsTest < ActionDispatch::IntegrationTest
  it "canonical for all ads page is home page" do
    visit ads_listall_path(locale: nil, type: "give")

    assert_canonical Capybara.current_host
  end

  it "canonical for all give ads page keeps locale" do
    visit ads_listall_path(locale: "es", type: "give")

    assert_canonical "#{Capybara.current_host}/es"
  end

  it "canonical for home page without trailing slash is itself" do
    visit ""

    assert_canonical Capybara.current_host
  end

  it "canonical for home page with trailing slash is itself wihtout slash" do
    visit "/"

    assert_canonical Capybara.current_host
  end

  it "canonical for home page keeps locale" do
    visit "/es"

    assert_canonical "#{Capybara.current_host}/es"
  end

  it "canonical for other pages is a self-reference" do
    visit ads_listall_path(locale: nil, type: "want")

    assert_canonical "#{Capybara.current_host}/ad/listall/ad_type/want"
  end

  it "canonical for other pages keeps locale" do
    visit ads_listall_path(locale: "es", type: "want")

    assert_canonical "#{Capybara.current_host}/es/ad/listall/ad_type/want"
  end

  private

  def assert_canonical(url)
    assert_selector \
      :xpath, "//link[@rel='canonical'][@href='#{url}']", visible: false
  end
end
