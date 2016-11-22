# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @ad = Ad.find params[:ad_id]
    @comment = @ad.comments.build(comment_params)

    if @comment.save
      if @ad.user != current_user
        CommentsMailer.create(@ad.id, @comment.filtered_body).deliver_later
      end
      flash[:notice] = t('nlt.comments.flash_ok')
    else
      flash[:alert] = t('nlt.comments.flash_ko')
    end

    redirect_to adslug_path(@ad, slug: @ad.slug)
  end

  private

  def comment_params
    params.require(:comment)
          .permit(:body)
          .merge(user_owner: current_user.id, ip: request.remote_ip)
  end
end
