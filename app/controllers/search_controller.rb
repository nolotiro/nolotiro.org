# frozen_string_literal: true
class SearchController < ApplicationController
  include StringUtils

  # GET /search
  def search
    @search = true
    @type = type_scope
    type_n = @type == 'give' ? 1 : 2

    @id = params[:woeid_code]

    if !positive_integer?(@id)
      redirect_to root_path, alert: I18n.t('nlt.no_location_specified')
    else
      @woeid = WoeidHelper.convert_woeid_name @id
      if params[:q].nil?
        @ads = []
      else
        @q = Riddle::Query.escape(params[:q])
        @ads = Ad.search @q,
                         page: params[:page],
                         star: true,
                         order: 'created_at DESC',
                         without: { status: 3 },
                         with: { woeid_code: @id, type: type_n }
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
end
