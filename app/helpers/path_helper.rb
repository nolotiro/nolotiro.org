# frozen_string_literal: true

module PathHelper
  def ad_listing_path(type, status = nil)
    return ads_listall_path(type: type, status: status) unless current_woeid

    ads_woeid_path(current_woeid, type: type, status: status)
  end

  def localized_url(locale)
    url_for(params.merge(locale: locale, only_path: false))
  end

  def canonical_url
    url_for(params.merge(only_path: false))
  end
end
