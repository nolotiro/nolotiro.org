# frozen_string_literal: true

class BlockingsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.blockings.find_or_create_by!(blocked_id: params[:blocked_id])

    redirect_to :back, notice: I18n.t('blockings.create.success')
  end

  def destroy
    current_user.blockings.destroy(params[:id])

    redirect_to :back, notice: I18n.t('blockings.destroy.success')
  end
end
