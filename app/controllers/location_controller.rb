class LocationController < ApplicationController
  include StringUtils

  # GET /es/location/change
  def ask
  end

  # POST /es/location/change
  # GET /es/location/change2?location=:location
  def list
    if params[:location]
      locations = WoeidHelper.search_by_name(params[:location])
      if not locations.nil? and locations.count == 1
        set_location locations[0].woeid
      else
        @locations = locations
      end
    end
  end

  # POST /es/location/change2
  def change
    if positive_integer?(params[:location])
      set_location params[:location]
    else
      locations = WoeidHelper.search_by_name(params[:location])
      if locations 
        set_location locations[0].woeid
      else
        redirect_to location_ask_path, alert: "Hubo un error con el cambio de su ubicación. Inténtelo de nuevo."
      end
    end
  end

  private

  def set_location woeid
    # receives woeid, set location for user
    if user_signed_in? 
      current_user.woeid = woeid
      current_user.save
    end
    cookies[:location] = woeid
    redirect_to ads_woeid_path(id: woeid, type: 'give')
  end

end
