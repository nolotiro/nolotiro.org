# frozen_string_literal: true

module Api
  class V1Controller < ApplicationController
    def ad_show
      @ad = Ad.find params[:id]
    end

    def woeid_show
      @type = type_scope
      @woeid = params[:id]

      @woeid_info = WoeidHelper.convert_woeid_name(@woeid)
      raise ActionController::RoutingError, 'Not Found' if @woeid_info.nil?

      @page = params[:page]
      @ads = Ad.public_send(@type)
               .available
               .by_woeid_code(@woeid)
               .recent_first
               .paginate(page: params[:page])
    end

    def woeid_list
      @section_locations = Ad.top_locations
    end
  end
end
