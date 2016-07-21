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

      if params[:q].nil?
        @ads = []
      else
        @q = Riddle::Query.escape(params[:q])
        @ads =
          Ad.search @q,
                    page: params[:page],
                    star: true,
                    order: 'created_at DESC',
                    with: { woeid_code: @id, type: type_n, status: status_n }
      end

      begin
        @no_results_search = true if @ads.count == 0
      rescue ThinkingSphinx::SphinxError
        @ads = []
        @no_results_search = true
      end

      render 'woeid/show'
    end
  end

  private

  def type_n
    @type == 'give' ? 1 : 2
  end

  def status_n
    case @status
    when 'available' then 1
    when 'booked' then 2
    when 'delivered' then 3
    end
  end
end
