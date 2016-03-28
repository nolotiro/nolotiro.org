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

    if params.has_key?(:id)
      @woeid = WoeidHelper.convert_woeid_name( params[:id], params[:locale])
    end

    if not @ads.any?
      @location_suggest = get_location_suggest # no results
      if @woeid
        @location_options = WoeidHelper.search_by_name(@woeid[:short], params[:locale])
      end
    end
  end

  private

  def type_scope
    params[:type] == 'want' ? params[:type] : 'give'
  end
end
