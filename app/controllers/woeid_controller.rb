# frozen_string_literal: true

class WoeidController < ApplicationController
  include StringUtils

  before_action :check_location

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show
    @type = type_scope || 'give'
    @status = status_scope || 'available'
    @q = params[:q]
    @page = params[:page]

    unless @page.nil? || positive_integer?(@page)
      raise ActionController::RoutingError, 'Not Found'
    end

    scope = Ad.public_send(@type).by_woeid_code(current_woeid).by_title(@q)
    scope = scope.public_send(@status) if @type == 'give'

    @ads = policy_scope(scope).includes(:user).recent_first.page(@page)
  end

  private

  def check_location
    redirect_to location_ask_path if user_signed_in? && user_woeid.nil?

    return unless current_woeid

    @woeid_info = WoeidHelper.convert_woeid_name(current_woeid)
  end
end
