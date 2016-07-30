# frozen_string_literal: true
module ApplicationHelper
  def messages_tab?
    params[:controller] == 'conversations'
  end

  def profile_tab?
    (params[:controller] == 'users' && params['action'] == 'profile') ||
      (params[:controller] == 'registrations' && params['action'] == 'edit')
  end

  def ad_tab?
    params[:controller] == 'users' && params['action'] == 'listads'
  end

  def meta_description
    general = t('nlt.meta_description')
    specific = content_for(:meta_description) if content_for?(:meta_description)
    content = specific ? "#{specific}. #{general}" : general

    tag :meta, name: 'description', content: content
  end

  def escape_privacy_data(text)
    if text
      text = text.gsub(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, ' ')
      text = text.gsub(/([9|6])+([0-9\s*]{8,})/, ' ')
      text = text.gsub(/whatsapp/, ' ')
      text = text.gsub(/whatsupp/, ' ')
      text = text.gsub(/whatsap/, ' ')
      text = text.gsub(/whatsap/, ' ')
      text = text.gsub(/watsap/, ' ')
      text = text.gsub(/guasap/, ' ')
      text = text.gsub(/wuassap/, ' ')
      text = text.gsub(/wuasap/, ' ')
      text = text.gsub(/wassap/, ' ')
      text = text.gsub(/wasap/, ' ')
      text = text.gsub(/guassapp/, ' ')
      text = text.gsub(/guassap/, ' ')
      text = text.gsub(/guasapp/, ' ')
      text = text.gsub(/guasap/, ' ')
      text = text.gsub(/guasp/, ' ')
      text
    end
  end

  def i18n_to_localeapp_in_locale(locale)
    langs = {
      gl: 20_650,
      pt: 20_648,
      nl: 24_068,
      it: 20_649,
      fr: 20_646,
      eu: 20_651,
      en: 20_647,
      de: 20_645,
      ca: 20_644
    }
    langs[locale]
  end

  def localized_url(locale)
    url_for(params.merge(locale: locale, only_path: false))
  end

  def errors_for(object)
    errs = object.errors
    return unless errs.any?

    content_tag(:div, id: 'error_explanation') do
      header = content_tag(:h2, t('nlt.save_failed'))
      list = content_tag(:ul) do
        safe_join(errs.full_messages.map { |m| content_tag(:li, m) }, "\n")
      end

      header + list
    end
  end

  def link_to_change_location(place, name = nil)
    title = name || place

    link_to title, location_change_path(location: place)
  end
end
