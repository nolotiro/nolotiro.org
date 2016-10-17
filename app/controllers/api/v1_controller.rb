# frozen_string_literal: true

module Api
  class V1Controller < ApplicationController
    def ad_show
      @ad = Ad.find params[:id]
    end

    def woeid_show
      @type = type_scope || 'give'
      @woeid = params[:id]
      @page = params[:page]

      @town = Town.find(@woeid)

      @ads = Ad.public_send(@type).by_woeid_code(@woeid)
      @ads = @ads.available if type_scope == :give
      @ads = @ads.recent_first.page(@page)
    end

    def woeid_list
      @section_locations = Ad.top_locations.ranked
    end
  end
end
