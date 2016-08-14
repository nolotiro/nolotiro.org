# frozen_string_literal: true
class UsersController < ApplicationController
  def listads
    @user = User.find(params[:id])
    authorize(@user)

    @type = type_scope
    @status = status_scope

    @ads = @user.ads
                .includes(:user)
                .public_send(@type)
                .paginate(page: params[:page])

    @ads = @ads.public_send(@status) if @status
  end

  def profile
    name_or_id = params[:username]
    @user = User.find_by(username: name_or_id) || User.find(name_or_id)
    authorize(@user)
  end

  private

  def status_scope
    return unless %w(available booked delivered).include?(params[:status])

    params[:status]
  end

  helper_method :status_scope
end
