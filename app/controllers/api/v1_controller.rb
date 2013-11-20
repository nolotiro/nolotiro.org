class Api::V1Controller < ApplicationController

  before_action :get_section_locations, only: [:woeid_list]

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
    @ads = ads.available.where(:woeid_code => @woeid).paginate(:page => params[:page])
  end

  def woeid_list
  end

end
