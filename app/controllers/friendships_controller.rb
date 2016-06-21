class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:id])
    friend = User.find params[:id]
    username = friend.username
    if @friendship.save
      flash[:notice] = "Added #{username} as a friend."
    else
      flash[:error] = "Error occurred when adding #{username} as a friend."
    end
    redirect_to profile_path(username)
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    username = @friendship.friend.username
    flash[:notice] = "Removed #{username} as a friend."
    redirect_to profile_path(friend.username)
  end

end
