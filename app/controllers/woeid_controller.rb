class WoeidController < ApplicationController

  #caches_action :show, :cache_path => Proc.new { |c| c.params }, unless: :current_user

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
              .paginate(:page => params[:page])

    if params[:id].present?
        @woeid = WoeidHelper.convert_woeid_name params[:id]
    end

    if params[:id].present? == true && (@id.match(/^(\d)+$/) == nil || @woeid == nil)
      redirect_to :controller => 'location', :action => 'ask'
    elsif not @ads.any?
      @location_suggest = get_location_suggest # no results
      if @woeid
        @location_options = WoeidHelper.search_by_name(@woeid[:short])
      end
    end
  end

  private

  def status_scope
    return 'available' unless %w(booked delivered).include?(params[:status])

    params[:status]
  end

  helper_method :status_scope
end
