# frozen_string_literal: true

class LocationController < ApplicationController
  include StringUtils

  def ask
  end

  def list
    if unique_location
      save_location unique_location
    else
      @locations = similar_locations
    end
  end

  def change
    if unique_location
      save_location unique_location
    else
      redirect_to location_ask_path, alert: "Hubo un error con el cambio de su ubicación. Inténtelo de nuevo."
    end
  end

  private

  def unique_location
    @unique_location ||= if positive_integer?(params[:location])
                           params[:location]
                         elsif similar_locations&.length == 1
                           similar_locations.first.id
                         end
  end

  def similar_locations
    @similar_locations ||= Town.matching_rank(params[:location])
  end

  def save_location(woeid)
    current_user.update!(woeid: woeid) if user_signed_in?

    redirect_to ads_woeid_path(woeid, type: "give")
  end
end
