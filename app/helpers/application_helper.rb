module ApplicationHelper

  def escape_privacy_data text
    if text
      text = text.gsub(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, ' ')
      text = text.gsub(/([9|6])+([0-9\s*]{8,})/, ' ')
      text
    end
  end

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(@woeid[:full])
  end

  def cache_key_for(key, current_user)
    key += current_user ? "user_" + current_user.admin?.to_s : "user_nil"
    Digest::MD5.hexdigest(key)
  end

  def i18n_to_localeapp_in_locale(locale)
    langs = {
      gl: 20650,
      pt: 20648,
      nl: 24068,
      it: 20649,
      fr: 20646,
      eu: 20651,
      en: 20647,
      de: 20645,
      ca: 20644
    }
    langs[locale]
  end

end
