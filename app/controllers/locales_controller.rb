# frozen_string_literal: true

class LocalesController < ApplicationController
  def show
    cookies.permanent[:locale] = locale

    redirect_to refered_url
  end

  private

  def referer_url
    URI.parse(request.referer || root_path)
  end

  def refered_url
    @refered_url = referer_url
    @refered_url.path = refered_path
    @refered_url.query = referer_url.query
    @refered_url.to_s
  end

  def referer_path
    referer_url.path
  end

  def refered_path
    return "/#{locale}" if referer_path.empty?

    segments = referer_path.split('/')
    segments[1] = locale if valid_locale?(segments[1])
    segments.join('/')
  end

  def locale
    params[:locale]
  end
end
