class WoeidController < ApplicationController

  before_action :convert_woeid_name, :get_id, :only => [:available, :booked, :delivered, :want]

  # GET /es/ad/listall/ad_type/give
  def listall_give
    @ads = Ad.give.paginate(:page => params[:page]) 
    @all = true
    @type = "give"
    @status = "all"
    render "show"
  end

  # GET /es/ad/listall/ad_type/give/status/available
  def listall_give_available
    @ads = Ad.give.available.paginate(:page => params[:page]) 
    @all = true
    @type = "give"
    @status = "available"
    render "show"
  end

  # GET /es/ad/listall/ad_type/give/status/booked
  def listall_give_booked
    @ads = Ad.give.booked.paginate(:page => params[:page]) 
    @all = true
    @type = "give"
    @status = "booked"
    render "show"
  end

  # GET /es/ad/listall/ad_type/give/status/delivered
  def listall_give_delivered
    @ads = Ad.give.delivered.paginate(:page => params[:page]) 
    @all = true
    @type = "give"
    @status = "delivered"
    render "show"
  end

  # GET /es/ad/listall/ad_type/want
  def listall_want
    @ads = Ad.want.paginate(:page => params[:page]) 
    @all = true
    @type = "want"
    render "show"
  end

  # GET /es/woeid/:id/give
  def available 
    @ads = Ad.give.available.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    if not @ads.any?
      @location_suggest = get_location_suggest # no results
      @location_options = WoeidHelper.search_by_name(WoeidHelper.convert_woeid_name(params[:id]).split(',')[0])
    end
    @type = "give"
    @status = "available"
    render "show"
  end

  # GET /es/woeid/:id/give/status/booked
  def booked 
    @ads = Ad.give.booked.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "give"
    @status = "booked"
    render "show"
  end

  # GET /es/woeid/:id/give/status/delivered
  def delivered 
    @ads = Ad.give.delivered.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "give"
    @status = "delivered"
    render "show"
  end

  # GET /es/woeid/:id/want
  def want 
    @ads = Ad.want.available.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "want"
    render "show"
  end

  private

  def get_id
    @id = params[:id]
  end

  def convert_woeid_name
    @woeid = WoeidHelper.convert_woeid_name params[:id]
  end

end
