class FriendshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:id])
    friend = User.find params[:id]
    username = friend.username
    if @friendship.save
      flash[:notice] = I18n.t('friendships.create.success', username: username)
    else
      flash[:error] = I18n.t('friendships.create.error', username: username)
    end
    redirect_to profile_path(username)
  end
  
  def destroy
    @friendship = current_user.friendships.find_by(:friend_id => params[:id])
    @friendship.destroy
    username = @friendship.friend.username
    flash[:notice] = I18n.t('friendships.destroy.success', username: username)
    redirect_to profile_path(username)
  end

end
