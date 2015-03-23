class LocationController < ApplicationController

  # GET /es/location/change
  def ask
    # show form for asking possible locations
    @location_suggest = get_location_suggest
  end

  # POST /es/location/change
  # GET /es/location/change2?location=:location
  def list
    # list possible locations 
    @location_suggest = get_location_suggest
    if params[:location]
      locations = WoeidHelper.search_by_name params[:location]
      if not locations.nil? and locations.count == 1
        set_location locations[0]
      else
        @location_asked = locations
      end
    end
  end

  # POST /es/location/change2
  def change
    if params[:location].to_i == 0 
      locations = WoeidHelper.search_by_name params[:location]
      set_location locations[0][1]
    else
      set_location params[:location]
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
