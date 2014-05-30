class SearchController < ApplicationController

  # GET /search
  def search
    # TODO: filter by want/give
    #
    @search = true
    @type =  params[:ad_type] == "give" ? 1 : 2

    @id = params[:woeid] || params[:woeid_code]
    @id = current_user.woeid if user_signed_in? and @id.nil?

    if @id.nil? 
      redirect_to location_ask_path 
    else 
      @woeid = WoeidHelper.convert_woeid_name @id
      if params[:q].nil?
        @ads = []
      else 
        @q = Riddle::Query.escape(params[:q])
        @ads = Ad.search @q,
          page: params[:page],
          star: true,
          without: {status: 3},
          with: {woeid_code: @id, type: @type}
      end
      if @ads.count == 0
        @no_results_search = true
      end
      render 'woeid/show'
    end

  end

end
