class LocationController < ApplicationController

  # GET /es/location/change
  def ask
    # show form for asking possible locations
    # TODO: cache?
    ip_address = Rails.env == "development" ? "87.218.80.79" : request.remote_ip
    @location_suggest = GeoHelper.suggest ip_address
  end

  # POST /es/location/change
  # GET /es/location/change2?location=:location
  def list
    # list possible locations 

    # TODO: cache?
    ip_address = Rails.env == "development" ? "87.218.80.79" : request.remote_ip
    @location_suggest = GeoHelper.suggest ip_address

    if params[:location]
      locations = WoeidHelper.search_by_name params[:location]
      if locations.count == 1
        set_location locations[0].woeid
      else
        @location_asked = locations
      end
    end
  end

  # POST /es/location/change2
  def change
    set_location params[:location]
  end

  private

  def set_location woeid
    # receives woeid, set location for user
    if user_signed_in? 
      current_user.woeid = woeid
      current_user.save
    end
    cookies[:location] = woeid
    redirect_to woeid_path(id: woeid, type: 'give')
  end

end
