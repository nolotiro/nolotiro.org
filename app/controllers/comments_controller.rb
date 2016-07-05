# frozen_string_literal: true
class CommentsController < ApplicationController

  before_action :authenticate_user!

  # POST /comment/create/ad_id/:id
  def create
    @ad = Ad.find params[:id]
    @comment = Comment.new({
      ads_id: params[:id],
      body: params[:body],
      user_owner: current_user.id,
      ip: request.remote_ip,
    })
    if @comment.save
      if @comment.ad.user != current_user
        CommentsMailer.create(params[:id], params[:body]).deliver_later
      end
      expire_action(controller: 'ads', action: 'show', ad: @comment.ad )
      redirect_to(ad_path(params[:id]), notice: t('nlt.comments.flash_ok'))
    else
      render template: 'ads/show'
    end
  end

end
