# frozen_string_literal: true

module PathHelper
  def ad_listing_path(type, status = nil)
    return ads_listall_path(type: type, status: status) unless current_woeid

    ads_woeid_path(current_woeid, type: type, status: status)
  end
end
