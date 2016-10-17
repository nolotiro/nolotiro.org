# frozen_string_literal: true

module AdTestHelpers
  def visit_ad_page(ad)
    visit adslug_path(ad, slug: ad.slug)
  end
end
