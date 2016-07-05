# frozen_string_literal: true
class RssController < ApplicationController
  layout false

  # GET '/rss/feed/woeid/:woeid/ad_type/:type'
  # GET '/rss/feed/woeid/:woeid/ad_type/give/status/:status'
  def feed
    # rss filter
    ads = Ad
    ads = params[:type] == 'want' ? ads.want : ads.give
    ads = ads.where(:woeid_code => params[:woeid])

    ads = case params[:status]
          when 1, nil
            ads.available
          when 2
            ads.booked
          when 3
            ads.delivered
          else
            ads
          end

    @ads = ads.limit(30)
  end
end
