class Legacy::MessagesController < ApplicationController

  before_filter :authenticate_user!

  # GET '/message/show/:id/subject/:subject'
  def show 
    @thread = Legacy::MessageThread.find params[:id]
  end

  # GET '/message/create/id_user_to/:user_id'
  # GET '/message/create/id_user_to/:user_id/subject/:subject'
  def new
    @user = User.find params[:user_id]
    @subject = params[:subject]
  end

  # POST '/message/create/id_user_to/:user_id'
  # POST '/message/create/id_user_to/:user_id/subject/:subject'
  def create
    @message = Legacy::Message.create_thread(
      current_user.id,
      params[:user_id],
      params[:message][:subject],
      params[:message][:body],
      request.remote_ip
    )
    if @message.save
      @user = User.find params[:user_id]
      MessagesMailer.create(
        @user.email,
        current_user.username,
        params[:message][:subject],
        params[:message][:body]
      ).deliver
      redirect_to message_show_path(@thread.id, @thread.subject.parameterize)
      render action: 'new'
    end
  end
  # POST '/message/reply/:id/to/:user_id'
  def reply
    # WIP  TODO
    @thread = Legacy::MessageThread.find params[:id]
    @user = User.find params[:user_id]

    @message = Legacy::Message.new(
      thread_id: @thread.id,
      ip: request.remote_ip,
      subject: @thread.subject,
      body: params[:body],
      user_from: current_user.id,
      user_to: @user.id
    )
    if @message.save
      MessagesMailer.create(
        @user.email,
        current_user.username,
        @thread.subject,
        params[:body]
      ).deliver
      redirect_to message_show_path(@thread.id, @thread.subject), notice: 'Message was successfully replied.'
    else
      # there was an error saving
      render action: 'new'

    end
  end

  # GET '/message/list'
  def list 
    @last_threads = Legacy::Message.get_threads_from_user(current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:thread_id, :ip, :subject, :body, :readed, :user_from, :user_to)
  end

end
