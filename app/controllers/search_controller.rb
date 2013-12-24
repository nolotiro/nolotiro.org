class SearchController < ApplicationController

  # GET /search
  def search
    # TODO: filter by want/give
    # TODO: filter by status
    #
    if params.has_key?(:woeid) or params.has_key?(:woeid_code)
      @id = params[:woeid] || params[:woeid_code]
    else
      # If its possible, we get woeid and ad type from the URL where the search was made
      params_referer = Rails.application.routes.recognize_path(request.referrer)
      @id = params_referer[:id]
      @status = params_referer[:action]
      @type = [:available, :delivered, :booked].include? @status ? "give" : "want"
    end
    # if we don't have an ID we get the location from, id: @ad.woeid_code the user preference
    if user_signed_in? and @id.nil?
      @id = current_user.woeid
    end
    # TODO: if the user isn't logged in ask for his location

    if @id.nil? 
      redirect_to location_ask_path 
    else 
      if params[:q].nil?
        @ads = []
      else 
        @q = Riddle::Query.escape(params[:q])
        @ads = Ad.search @q,
          :page => params[:page],
          :without => {:status => 3},
          :with => {:woeid_code => @id, :type => 1}
      end
      if @ads.count == 0
        @no_results_search = true
      end
      render 'woeid/show'
    end

  end

end
