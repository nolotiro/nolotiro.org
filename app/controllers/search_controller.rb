# frozen_string_literal: true
class SearchController < ApplicationController
  include StringUtils

  # GET /search
  def search
    @search = true
    @type = type_scope
    @status = status_scope
    @id = params[:woeid_code]

    if !positive_integer?(@id)
      redirect_to root_path, alert: I18n.t('nlt.no_location_specified')
    else
      @woeid = WoeidHelper.convert_woeid_name @id
      @q = params[:q]

      @ads = Ad.includes(:user)
               .public_send(@type)
               .public_send(@status)
               .by_woeid_code(@id)
               .by_title(@q)
               .paginate(page: params[:page])

      @no_results_search = true unless @ads.any?

      render 'woeid/show'
    end
  end
end
