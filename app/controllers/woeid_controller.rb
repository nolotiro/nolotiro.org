class WoeidController < ApplicationController

  before_action :convert_woeid_name

  def want 
    @ads = Ad.want.available.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "want"
    render "show"
  end

  def available 
    @ads = Ad.give.available.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "give"
    @status = "available"
    render "show"
  end

  def booked 
    @ads = Ad.give.booked.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "give"
    @status = "booked"
    render "show"
  end

  def delivered 
    @ads = Ad.give.delivered.where(:woeid_code => params[:id]).paginate(:page => params[:page])
    @type = "give"
    @status = "delivered"
    render "show"
  end

  private

  def convert_woeid_name
    @woeid = WoeidHelper.convert_woeid_name params[:id]
  end

end
