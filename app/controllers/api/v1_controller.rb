# frozen_string_literal: true
module Api
  class V1Controller < ApplicationController
    def ad_show
      @ad = Ad.find params[:id]
    end

    def woeid_show
      ads = if params[:type] == 'give'
              Ad.give
            else
              Ad.want
            end
      @woeid = params[:id]
      @page = params[:page]
      @ads = ads.available
                .where(woeid_code: @woeid)
                .recent_first
                .paginate(page: params[:page])
    end

    def woeid_list
      @section_locations = Ad.top_locations(20)
    end
  end
end
