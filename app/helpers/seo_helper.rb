# frozen_string_literal: true

module SeoHelper
  def meta_title
    content_tag(:title, "#{content_for(:meta_title)} - nolotiro.org")
  end

  def meta_description
    general = t('nlt.meta_description')
    specific = content_for(:meta_description) if content_for?(:meta_description)
    content = specific ? "#{specific}. #{general}" : general

    tag :meta, name: 'description', content: content
  end

  def meta_robots
    return unless content_for?(:robots)

    tag :meta, name: 'robots', content: content_for(:robots)
  end

  def rel_canonical
    tag :link, rel: 'canonical', href: canonical_url
  end

  def rel_alternates
    x_default = tag :link, rel: 'alternate',
                           href: localized_url(nil),
                           hreflang: 'x-default'

    alternates = I18n.available_locales.map do |locale|
      tag :link, rel: 'alternate', href: localized_url(locale), hreflang: locale
    end

    x_default + safe_join(alternates)
  end

  private

  def localized_url(locale)
    url_for(params.merge(locale: locale, only_path: false))
  end

  def canonical_url
    url_for(params.except(:q).merge(only_path: false))
  end
end
