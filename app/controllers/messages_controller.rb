class MessagesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @box = params[:box] || 'inbox'
    @messages = current_user.mailbox.inbox if @box == 'inbox'
    @messages = current_user.mailbox.sentbox if @box == 'sent'
    @messages = current_user.mailbox.trash if @box == 'trash'
    @messages = current_user.mailbox.archive if @box == 'archive'
    @messages = @messages.paginate(:page => params[:page], :total_entries => @messages.to_a.size)
    session[:last_mailbox] = @box
  end

  def new
    @message = Message.new
    if params[:user_id]
      @message.recipients = User.find(params[:user_id]).id 
    end
  end

  def create
    @message = Message.new message_params
    @message.sender_id = current_user.id

    if @message.conversation_id
      @conversation = Conversation.find(@message.conversation_id)
      unless @conversation.is_participant?(current_user) or current_user.admin?
        flash[:alert] = "You do not have permission to view that conversation."
        return redirect_to root_path
      end
      receipt = current_user.reply_to_conversation(@conversation, @message.body, nil, true, true, @message.attachment)
    else
      @message.recipients = User.find(params[:message][:recipients])
      unless @message.valid?
        return render :new
      end
      receipt = current_user.send_message(@message.recipients, @message.body, @message.subject, true, @message.attachment)
    end
    flash[:notice] = "Message sent."

    redirect_to message_path(receipt.conversation)
  end

  def show
    @conversation = Conversation.find_by_id(params[:id])
    unless @conversation.is_participant?(current_user) or current_user.admin?
      flash[:alert] = "You do not have permission to view that conversation."
      return redirect_to root_path
    end
    @message = Message.new conversation_id: @conversation.id
    current_user.mark_as_read(@conversation)
  end

  def move
    mailbox = params[:mailbox]
    conversation = Conversation.find_by_id(params[:id])
    if conversation
      current_user.send(mailbox, conversation)
      flash[:notice] = "Message sent to #{mailbox}."
    else
      conversations = Conversation.find(params[:conversations])
      conversations.each { |c| current_user.send(mailbox, c) }
      flash[:notice] = "Messages sent to #{mailbox}."
    end
    redirect_to messages_path(box: params[:current_box])
  end

  def untrash
    conversation = Conversation.find(params[:id])
    current_user.untrash(conversation)
    flash[:notice] = "Message untrashed."
    redirect_to messages_path(:box => 'inbox')
  end

  def search
    @search = params[:search]
    @messages = current_user.search_messages(@search)
    render :index
  end

  private 
  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:conversation_id, :body, :subject, :recipients, :sender_id)
  end

end
