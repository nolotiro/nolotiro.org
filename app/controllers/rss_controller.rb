# frozen_string_literal: true

class RssController < ApplicationController
  layout false

  def feed
    ads = Ad
    ads = params[:type] == 'want' ? ads.want.available : ads.give
    ads = ads.by_woeid_code(params[:woeid])

    @ads = ads.limit(30)
  end
end
