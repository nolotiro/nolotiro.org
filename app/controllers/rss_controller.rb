# frozen_string_literal: true

class RssController < ApplicationController
  layout false

  # GET '/rss/feed/woeid/:woeid/ad_type/:type'
  # GET '/rss/feed/woeid/:woeid/ad_type/give/status/:status'
  def feed
    # rss filter
    ads = Ad
    ads = params[:type] == 'want' ? ads.want.available : ads.give
    ads = ads.by_woeid_code(params[:woeid])

    @ads = ads.limit(30)
  end
end
