# frozen_string_literal: true
require 'active_support/concern'

module MultiLingualizable
  extend ActiveSupport::Concern

  included { before_action :set_locale }

  class_methods do
    def default_url_options(_options = {})
      { locale: I18n.locale }
    end
  end

  def set_locale
    cookies.permanent[:locale] = params[:lang] if valid_locale?(params[:lang])

    I18n.locale =
      params_locale || cookie_locale || browser_locale || default_locale
  end

  def valid_locale?(code)
    return false unless code.present?

    I18n.available_locales.include?(code.to_sym)
  end

  def params_locale
    params[:locale].presence
  end

  def cookie_locale
    cookies.permanent[:locale].presence
  end

  def browser_locale
    http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def default_locale
    I18n.default_locale
  end
end
