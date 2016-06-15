module WebMocking
  def mocking_yahoo_woeid_info(woeid, locale = I18n.locale)
    VCR.use_cassette("woeid_#{woeid}_info_#{locale}") { yield }
  end

  def mocking_yahoo_woeid_similar(woeid, locale = I18n.locale)
    VCR.use_cassette("woeid_#{woeid}_similar_#{locale}") { yield }
  end
end
