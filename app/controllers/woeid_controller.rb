class WoeidController < ApplicationController

  def show 
    @woeid = WoeidHelper.convert_woeid_name params[:id]
    case params[:type] 
    when 'give'
      type = 1
    when 'want'
      type = 2
    else
      type = 1
    end
    @ads = Ad.where(:woeid_code => params[:id], :type => type).paginate(:page => params[:page])
  end

end
