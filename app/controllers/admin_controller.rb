class AdminController < ApplicationController

  before_filter :authenticate_user!
  
  def become
    return unless current_user.admin?
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url 
  end

end
