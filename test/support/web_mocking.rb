require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
end

module WebMocking
  def self.js_resource_blacklist
    [
      'http://pagead2.googlesyndication.com/pagead/js/*',
      'http://www.google.com/jsapi',
      'http://connect.facebook.net/es_ES/sdk.js*',
      'https://www.facebook.com/v2.3/plugins/like.php*',
      'http://staticxx.facebook.com/connect/xd_arbiter.php*',
      'http://platform.twitter.com/*',
      'http://www.google-analytics.com/analytics.js',
      'https://googleads.g.doubleclick.net/pagead/*'
    ]
  end

  def mocking_yahoo_woeid_info(woeid, locale = I18n.locale)
    VCR.use_cassette("woeid_#{woeid}_info_#{locale}") { yield }
  end

  def mocking_yahoo_woeid_similar(name, locale = I18n.locale)
    VCR.use_cassette("woeid_#{name}_similar_#{locale}") { yield }
  end
end
