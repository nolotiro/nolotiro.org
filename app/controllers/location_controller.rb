# frozen_string_literal: true

class LocationController < ApplicationController
  include StringUtils

  # GET /es/location/change
  def ask
  end

  # POST /es/location/change
  # GET /es/location/change2?location=:location
  def list
    if unique_location
      save_location unique_location
    else
      @locations = similar_locations
    end
  end

  # POST /es/location/change2
  def change
    if unique_location
      save_location unique_location
    else
      redirect_to location_ask_path, alert: 'Hubo un error con el cambio de su ubicación. Inténtelo de nuevo.'
    end
  end

  private

  def unique_location
    @unique_location ||= if positive_integer?(params[:location])
                           params[:location]
                         elsif similar_locations&.count == 1
                           similar_locations.first.woeid
                         end
  end

  def similar_locations
    @similar_locations ||= WoeidHelper.search_by_name(params[:location])
  end

  def save_location(woeid)
    current_user.update!(woeid: woeid) if user_signed_in?

    redirect_to ads_woeid_path(woeid, type: 'give')
  end
end
