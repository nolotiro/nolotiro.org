# frozen_string_literal: true

module SeoHelper
  include PathHelper

  def page_title
    content_tag(:title, "#{content_for(:title)} - nolotiro.org")
  end

  def listing_page_title
    key = params[:type] == "want" ? "requests" : "gifts"

    main = if current_woeid
             t("nlt.location_#{key}", location: @town.fullname)
           else
             t("nlt.all_#{key}")
           end

    return main unless params[:page]

    t("nlt.title_with_page", title: main, page: params[:page])
  end

  def meta_description
    general = t("nlt.meta_description")
    specific = content_for(:meta_description) if content_for?(:meta_description)
    content = specific ? "#{specific}. #{general}" : general

    tag :meta, name: "description", content: content
  end

  def meta_robots
    return unless content_for?(:robots)

    tag :meta, name: "robots", content: content_for(:robots)
  end

  def meta_open_graph
    safe_join([meta_og_title, meta_og_type, meta_og_url, meta_og_image])
  end

  def meta_og_title
    tag :meta, property: "og:title", content: content_for(:title)
  end

  def meta_og_type
    tag :meta, property: "og:type", content: "article"
  end

  def meta_og_url
    tag :meta, property: "og:url", content: canonical_url
  end

  def meta_og_image
    content = if content_for?(:og_image)
                content_for(:og_image)
              else
                asset_url("nolotiro_logo.png")
              end

    tag :meta, property: "og:image", content: content
  end

  def rel_canonical
    tag :link, rel: "canonical", href: canonical_url
  end

  def rel_alternates
    x_default = tag :link, rel: "alternate",
                           href: localized_url(nil),
                           hreflang: "x-default"

    alternates = I18n.available_locales.map do |locale|
      tag :link, rel: "alternate", href: localized_url(locale), hreflang: locale
    end

    x_default + safe_join(alternates)
  end
end
