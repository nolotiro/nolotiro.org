# frozen_string_literal: true
class AdminController < ApplicationController
  before_action :authenticate_user!, :authorize_admin!

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

  private

  def authorize_admin!
    authorize :admin
  end
end
