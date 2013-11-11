class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
  	Comment.create({
  		ads_id: params[:id],
  		user_owner: current_user.id,
    	body: params[:body],
    	date_created: DateTime.now,
    	ip: request.remote_ip,
	})
	# TODO: alert
	# TODO: mailer to ad_owner
	redirect_to(ad_path(params[:id]))
  end
end
