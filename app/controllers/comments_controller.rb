class CommentsController < ApplicationController

  before_filter :authenticate_user!

  # POST /comment/create/ad_id/:id
  def create
    expire_action(controller: '/ads', action: 'show')
    comment = Comment.new({
      ads_id: params[:id],
      body: params[:body],
      user_owner: current_user.id,
      ip: request.remote_ip,
    })
    if comment.save
      CommentsMailer.create(params[:id], params[:body]).deliver_later
      redirect_to(ad_path(params[:id]), notice: t('nlt.comments.flash_ok'))
    else
      redirect_to(:back, flash: {error: t('nlt.comments.flash_ko')}) 
    end
  end

end
