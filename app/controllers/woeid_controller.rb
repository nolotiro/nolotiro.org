class WoeidController < ApplicationController

  #caches_action :show, :cache_path => Proc.new { |c| c.params }, unless: :current_user

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show
    @id = params[:id]
    @type = params[:type]
    @status = params[:status].nil? ? 'available' : params[:status]

    case @status
    when 'available'
      st = 1
    when 'booked'
      st = 2
    when 'delivered'
      st = 3
    else
      st = 1
    end
    case @type
    when 'give'
      ty = 1
    when 'want'
      ty = 2
    else
      ty = 1
    end

    @ads = Ad.includes(:user).by_type(ty).by_status(st).by_woeid_code(@id).paginate(:page => params[:page])

    if params.has_key?(:id)
      @woeid = WoeidHelper.convert_woeid_name params[:id]
    else
      @all = true # se trata de un listall
    end

    if not @ads.any?
      @location_suggest = get_location_suggest # no results
      if @woeid
        @location_options = WoeidHelper.search_by_name(@woeid[:short])
      end
    end
    render "show"
  end

end
