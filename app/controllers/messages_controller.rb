class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def show 
    @thread = MessageThread.find params[:id]
  end

  def create
  end

  def reply
  end

  def list 
    @last_threads = current_user.last_threads
  end

end
