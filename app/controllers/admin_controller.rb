class AdminController < ApplicationController

  before_filter :authenticate_user!
  
  def become
    # FIXME: should be doing this in cancan (app/models/ability.rb) 
    return unless current_user.admin?
    user = User.find(params[:id])
    sign_in(:user, user)
    flash[:notice] = "Becoming user #{user.username}"
    redirect_to root_url 
  end

  def lock
    # FIXME: should be doing this in cancan (app/models/ability.rb) 
    return unless current_user.admin?
    user = User.find(params[:id])
    user.lock!
    flash[:notice] = "Successfully locked user #{user.username}. The user can't log in."
    redirect_to root_url 
  end

  def unlock
    # FIXME: should be doing this in cancan (app/models/ability.rb) 
    return unless current_user.admin?
    user = User.find(params[:id])
    user.unlock!
    flash[:notice] = "Successfully unlocked user #{user.username}. The user can log in."
    redirect_to root_url 
  end

end
