# frozen_string_literal: true
class LocationController < ApplicationController
  include StringUtils

  # GET /es/location/change
  def ask
  end

  # POST /es/location/change
  # GET /es/location/change2?location=:location
  def list
    return unless params[:location]

    if similar_locations && similar_locations.count == 1
      save_location similar_locations[0].woeid
    else
      @locations = similar_locations
    end
  end

  # POST /es/location/change2
  def change
    if positive_integer?(params[:location])
      save_location params[:location]
    else
      if similar_locations & similar_locations.count == 1
        save_location similar_locations[0].woeid
      else
        redirect_to location_ask_path, alert: 'Hubo un error con el cambio de su ubicación. Inténtelo de nuevo.'
      end
    end
  end

  private

  def similar_locations
    @similar_locations ||= WoeidHelper.search_by_name(params[:location])
  end

  def save_location(woeid)
    # receives woeid, set location for user
    if user_signed_in?
      current_user.woeid = woeid
      current_user.save
    end
    cookies[:location] = woeid
    redirect_to ads_woeid_path(id: woeid, type: 'give')
  end
end
