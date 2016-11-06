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

  def localized_url(locale)
    url_for(params.merge(locale: locale, only_path: false))
  end

  def canonical_url
    url_for(params.except(:q).merge(only_path: false))
  end
end
