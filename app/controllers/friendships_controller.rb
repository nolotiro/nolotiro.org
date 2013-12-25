class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:id])
    friend = User.find params[:id]
    if @friendship.save
      flash[:notice] = "Added #{friend.username} as a friend."
      redirect_to profile_path(friend.username)
    else
      flash[:error] = "Error occurred when adding #{friend.username} as a friend."
      redirect_to profile_path(friend.username)
    end
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Successfully destroyed friendship :("
    redirect_to profile_path(friend.username)
  end

end
