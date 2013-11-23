class MessagesController < ApplicationController
  before_filter :authenticate_user!

  # GET '/message/show/:id/subject/:subject'
  def show 
    @thread = MessageThread.find params[:id]
  end

  # GET '/message/create/id_user_to/:user_id'
  # GET '/message/create/id_user_to/:user_id/subject/:subject'
  def new
    @user = User.find params[:user_id]
    @subject = params[:subject]
    @message = Message.new
  end

  # POST '/message/create/id_user_to/:user_id'
  # POST '/message/create/id_user_to/:user_id/subject/:subject'
  def create
    @user = User.find params[:user_id]
    puts params
    @thread = MessageThread.create(
      subject: params[:message][:subject],
      last_speaker: current_user.id,
      unread: 1
    )
    @message = Message.new(
      thread_id: @thread.id,
      date_created: DateTime.now,
      ip: request.remote_ip,
      subject: params[:message][:subject],
      body: params[:message][:body],
      user_from: current_user.id,
      user_to: @user.id
    )

    if @message.save
      redirect_to thread_path(@thread), notice: 'Message was successfully created.'
    else
      render action: 'new'
    end
  end

  # POST '/message/reply/:id/to/:message_id'
  def reply
  end

  # GET '/message/list'
  def list 
    @last_threads = current_user.last_threads
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:thread_id, :date_created, :ip, :subject, :body, :readed, :user_from, :user_to)
  end

end
