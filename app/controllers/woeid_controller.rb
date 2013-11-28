class WoeidController < ApplicationController

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show 
    @id = params[:id]
    @type = params[:type]
    @status = params[:status]
    if @type == "give" # regalo
      ads = Ad.give 
      case @status
      when "booked"
        ads = ads.booked
      when "delivered"
        ads = ads.delivered
      else
        ads = ads.available
      end
    else
      ads = Ad.want  # busco
    end
    if params.has_key?(:id) 
      ads = ads.where(:woeid_code => params[:id])
      @woeid = WoeidHelper.convert_woeid_name params[:id]
    else
      @all = true # se trata de un listall
    end
    @ads = ads.includes(:user).paginate(:page => params[:page])
    if not @ads.any?
      @location_suggest = get_location_suggest # no results
      @location_options = WoeidHelper.search_by_name(WoeidHelper.convert_woeid_name(params[:id]).split(',')[0])
    end
    render "show"
  end

end
