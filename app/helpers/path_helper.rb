# frozen_string_literal: true

module PathHelper
  def ad_listing_path(type, status = nil)
    return ads_listall_path(type: type, status: status) unless current_woeid

    ads_woeid_path(current_woeid, type: type, status: status)
  end

  def localized_url(locale)
    request.original_url
           .chomp('/')
           .sub(base_with_locale(params[:locale]), base_with_locale(locale))
  end

  def canonical_url
    return base_with_locale(params[:locale]) if home_path? || listall_give_path?

    url_for(params.merge(locale: params[:locale], only_path: false))
  end

  def home_path?
    return true if current_page?('/')

    I18n.available_locales.any? { |locale| current_page?("/#{locale}") }
  end

  def listall_give_path?
    request.path =~ %r{/listall/ad_type/give\Z}
  end

  def base_with_locale(locale)
    [request.base_url, locale].compact.join('/')
  end
end
