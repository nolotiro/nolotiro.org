# frozen_string_literal: true

require 'support/web_mocking'

module AdTestHelpers
  include WebMocking

  def visit_ad_page(ad)
    mocking_yahoo_woeid_info(ad.woeid_code) do
      visit adslug_path(ad, slug: ad.slug)
    end
  end
end
