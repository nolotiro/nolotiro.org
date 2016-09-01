# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
end

module WebMocking
  def mocking_yahoo_woeid_info(woeid, locale = I18n.locale)
    VCR.use_cassette("woeid_#{woeid}_info_#{locale}") { yield }
  end

  def mocking_yahoo_woeid_similar(name, locale = I18n.locale)
    VCR.use_cassette("woeid_#{name}_similar_#{locale}") { yield }
  end
end
