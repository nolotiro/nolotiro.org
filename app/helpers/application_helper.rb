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

  def recaptcha
    recaptcha_tags(display: { theme: 'white' }, ajax: true, hl: I18n.locale)
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
