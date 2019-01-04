# frozen_string_literal: true

require "support/web_mocking"

module AdTestHelpers
  def visit_ad_page(ad)
    visit adslug_path(ad, slug: ad.slug)
  end
end
