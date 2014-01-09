class AdminController < ApplicationController

  before_filter :authenticate_user!
  authorize_resource :class => false
  
  def become
    user = User.find(params[:id])
    sign_in(:user, user)
    flash[:notice] = "Becoming user #{user.username}"
    redirect_to root_url 
  end

  def lock
    user = User.find(params[:id])
    user.lock!
    flash[:notice] = "Successfully locked user #{user.username}. The user can't log in."
    redirect_to profile_url(user) 
  end

  def unlock
    user = User.find(params[:id])
    user.unlock!
    flash[:notice] = "Successfully unlocked user #{user.username}. The user can log in."
    redirect_to profile_url(user) 
  end

end
