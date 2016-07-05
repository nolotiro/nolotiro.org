# frozen_string_literal: true
class WoeidController < ApplicationController
  # caches_action :show, :cache_path => Proc.new { |c| c.params }, unless: :current_user

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show
    @id = params[:id]
    @type = type_scope
    @status = status_scope

    @ads = Ad.includes(:user)
             .public_send(@type)
             .public_send(@status)
             .by_woeid_code(@id)
             .paginate(page: params[:page])

    @woeid = WoeidHelper.convert_woeid_name(@id) if @id.present?

    if @id.present? == true && @woeid == nil
      raise ActionController::RoutingError.new('Not Found')
    end

    return if @ads.any?

    @location_options = WoeidHelper.search_by_name(@woeid[:short]) if @woeid
  end
end
