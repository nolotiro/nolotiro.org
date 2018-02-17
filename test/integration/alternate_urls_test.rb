# frozen_string_literal: true

require "test_helper"

class AlternateUrlsTest < ActionDispatch::IntegrationTest
  it "sets alternate locales for all give ads page without locale" do
    visit ads_listall_path(locale: nil, type: "give")

    assert_alternates_for "/ad/listall/ad_type/give"
  end

  it "sets alternate locales for all give ads page with locale" do
    visit ads_listall_path(locale: "es", type: "give")

    assert_alternates_for "/ad/listall/ad_type/give"
  end

  it "sets alternate locales for home page without locale" do
    visit ""

    assert_alternates_for "/"
  end

  it "sets alternate locales for home page with locale" do
    visit "/es"

    assert_alternates_for "/"
  end

  it "sets alternate locales for home page with trailing slash" do
    visit "/"

    assert_alternates_for "/"
  end

  it "sets alternate locales for urls without locale in other pages" do
    visit ads_listall_path(locale: nil, type: "want")

    assert_alternates_for "/ad/listall/ad_type/want"
  end

  it "sets alternate locales for urls with locale in other pages" do
    visit ads_listall_path(locale: "es", type: "want")

    assert_alternates_for "/ad/listall/ad_type/want"
  end

  private

  def assert_alternates_for(path)
    url = if path == "/"
            Capybara.current_host
          else
            "#{Capybara.current_host}#{path}"
          end

    assert_alternate url, "x-default"

    I18n.available_locales.each do |locale|
      with_locale = "#{Capybara.current_host}/#{locale}"
      url = path == "/" ? with_locale : "#{with_locale}#{path}"

      assert_alternate url, locale
    end
  end

  def assert_alternate(url, locale)
    assert_selector \
      :xpath,
      "//link[@rel='alternate'][@href='#{url}'][@hreflang='#{locale}']",
      visible: false
  end
end
