module ApplicationHelper

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(WoeidHelper.convert_woeid_name(woeid).split(',')[0])
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
