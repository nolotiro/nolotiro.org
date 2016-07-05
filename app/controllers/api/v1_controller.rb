# frozen_string_literal: true
module Api
  class V1Controller < ApplicationController
    def ad_show
      @ad = Ad.find params[:id]
    end

    def woeid_show
      if params[:type] == 'give'
        ads = Ad.give
      else
        ads = Ad.want
      end
      @woeid = params[:id]
      @page = params[:page]
      @ads = ads.available
                .where(:woeid_code => @woeid)
                .paginate(:page => params[:page])
    end

    def woeid_list
     @section_locations = AdHelper.get_locations_ranking
    end
  end
end
