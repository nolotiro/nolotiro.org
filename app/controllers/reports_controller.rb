# frozen_string_literal: true

#
# Handles user content reporting
#
class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user

  def create
    if current_user.report!(@user)
      redirect_to root_path, notice: I18n.t('reports.create.success_banned')
    else
      redirect_back fallback_location: profile_path(@user),
                    notice: I18n.t('reports.create.success_reported')
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end
