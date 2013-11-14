class UsersController < ApplicationController

  # GET '/ad/listuser/id/:id'
  def listads
    # ads lists for user
    @user = User.find(params[:id])
    @ads = @user.ads.paginate(:page => params[:page])
  end

  # GET '/profile/:username'
  def profile
    # public profile for user
    @user = User.find_by_username(params[:username])
  end

end
