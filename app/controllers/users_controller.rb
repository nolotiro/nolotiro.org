class UsersController < ApplicationController

    # GET '/ad/listuser/id/:id'
    def listads
      # ads lists for user
      @user = User.find(params[:id])
      @ads = @user.ads.paginate(:page => params[:page])
    end

    # GET '/profile/:id'
    def profile
      # public profile for user
      @user = User.find(params[:id])
    end

end
