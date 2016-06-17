# frozen_string_literal: true
class WoeidController < ApplicationController
  include StringUtils

  # GET /es/woeid/:id/:type
  # GET /es/woeid/:id/:type/status/:status
  # GET /es/ad/listall/ad_type/:type
  # GET /es/ad/listall/ad_type/:type/status/:status
  def show
    @id = params[:id]
    @type = type_scope
    @status = status_scope
    @q = params[:q]
    page = params[:page]

    unless page.nil? || positive_integer?(page)
      raise ActionController::RoutingError, 'Not Found'
    end

    @ads = policy_scope(Ad).includes(:user)
                           .public_send(@type)
                           .public_send(@status)
                           .by_woeid_code(@id)
                           .by_title(@q)
                           .paginate(page: page)

    return unless @id.present?

    @woeid = WoeidHelper.convert_woeid_name(@id)

    raise ActionController::RoutingError, 'Not Found' if @woeid.nil?
  end
end
