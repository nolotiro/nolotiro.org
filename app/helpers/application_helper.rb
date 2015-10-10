module ApplicationHelper

  def escape_privacy_data text
    if text
      text = text.gsub(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, ' ')
      text = text.gsub(/([9|6])+([0-9\s*]{8,})/, ' ')
      text = text.gsub(/whatsapp/, ' ')
      text = text.gsub(/whatsup/, ' ')
      text = text.gsub(/watsup/, ' ')
      text = text.gsub(/guasap/, ' ')
      text = text.gsub(/wuassap/, ' ')
      text = text.gsub(/wuasap/, ' ')
      text
    end
  end

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(woeid.to_s)
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

  def convert_provider provider
    provider = :google if provider == :google_oauth2
    provider.to_s.titleize
  end

  def convert_provider_fa provider
    case provider
      when :google_oauth2 then "fa-google-plus-square"
      when :facebook then "fa-facebook-square"
      else "fa-facebook-square"
    end
  end

end
