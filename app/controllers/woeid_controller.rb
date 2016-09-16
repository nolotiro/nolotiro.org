# frozen_string_literal: true

class WoeidController < ApplicationController
  include StringUtils

  before_action :check_location

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show
    @type = type_scope
    @status = status_scope
    @q = params[:q]
    page = params[:page]

    unless page.nil? || positive_integer?(page)
      raise ActionController::RoutingError, 'Not Found'
    end

    if @id
      @woeid = WoeidHelper.convert_woeid_name(@id)

      raise ActionController::RoutingError, 'Not Found' if @woeid.nil?
    end

    scope = Ad.public_send(@type)
              .public_send(@status)
              .by_woeid_code(@id)
              .by_title(@q)

    @ads = policy_scope(scope).includes(:user).recent_first.paginate(page: page)
  end

  private

  def resolve_woeid
    return if request.path =~ %r{/listall/}

    params[:id].presence || user_woeid
  end

  def check_location
    redirect_to location_ask_path if user_signed_in? && user_woeid.nil?

    @id = resolve_woeid
  end

  def user_woeid
    current_user.try(:woeid)
  end
end
