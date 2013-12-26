class CommentsController < ApplicationController

  before_filter :authenticate_user!

  # POST /comment/create/ad_id/:id
  def create
    expire_action(controller: '/ads', action: 'show')
    Comment.create({
      ads_id: params[:id],
      body: params[:body],
      user_owner: current_user.id,
      ip: request.remote_ip,
    })
    flash[:notice] = "Comment created"
    CommentsMailer.create(params[:id], params[:body]).deliver
    redirect_to(ad_path(params[:id]))
  end

end
