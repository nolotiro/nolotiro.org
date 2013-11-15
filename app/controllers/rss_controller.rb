class RssController < ApplicationController

  layout false

  # GET '/rss/feed/woeid/:woeid/ad_type/:type'
  # GET '/rss/feed/woeid/:woeid/ad_type/give/status/:status'
  def feed
    # rss filter 
    ads = Ad
    ads = params[:type] == "want" ? ads.want : ads.give
    ads = ads.where(:woeid_code => params[:woeid])

    if params[:type] == "want"
      @ads = ads
    else
      if params[:status].nil? 
        ads = ads.available
        case params[:status]
        when 1
          ads = ads.available
        when 2
          ads = ads.booked
        when 3
          ads = ads.delivered
        else
          ads = ads.available
        end
      end
    end

    @ads = ads.limit(30)
  end

end
