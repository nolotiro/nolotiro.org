# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_ad

  def new
    session[:return_to] = referer_path
  end

  def create
    @ad.reports.find_or_create_by!(reporter: current_user) do |report|
      report.reason = report_params[:reason]
    end

    message = if @ad.user.reported_too_much?
                @ad.user.ban!

                I18n.t('reports.create.success_reported')
              else
                I18n.t('reports.create.success_banned')
              end

    redirect_to redirect_path, notice: message
  end

  private

  def report_params
    params.require(:report).permit(:reason)
  end

  def load_ad
    @ad = Ad.find(params[:ad_id])
  end

  def redirect_path
    session.delete(:return_to) || root_path
  end

  def referer_path
    URI(request.referer).path
  rescue
    root_path
  end
end
