class MessagesController < ApplicationController

  require 'will_paginate/array'

  before_filter :authenticate_user!

  def index
    @box = params[:box] || 'inbox'
    @conversations = current_user.mailbox.inbox if @box == 'inbox'
    @conversations = current_user.mailbox.sentbox if @box == 'sent'
    @conversations = current_user.mailbox.trash if @box == 'trash'
    @conversations = current_user.mailbox.archive if @box == 'archive'
    @conversations = @conversations.sort_by {|c| c.last_message.created_at}.reverse
    @conversations = @conversations.paginate(:page => params[:page], :total_entries => @conversations.to_a.size)
    session[:last_mailbox] = @box
  end

  def new
    @message = Mailboxer::Message.new
    @recipient = User.find(params[:user_id])
    if params[:user_id]
      @message.recipients = @recipient.id 
    end
  end

  def create
    @message = Mailboxer::Message.new message_params
    @message.sender = current_user
    # FIXME: this should be on model (validation)
    if @message.sender.id == recipient_id
      return redirect_to message_create_url(user_id: recipient_id), notice: I18n.t("mailboxer.notifications.error_same_user")
    end
    if @message.conversation_id
      @conversation = Mailboxer::Conversation.find(@message.conversation_id)
      #@conversation = conversations.find(@message.conversation_id)
      # FIXME: ACL should be on app/models/ability.rb
      unless @conversation.is_participant?(current_user) or current_user.admin?
        flash.now[:alert] = I18n.t('nlt.permission_denied')
        return redirect_to root_path
      end

      unless @message.valid?
        return render_show_with(interlocutor(@conversation))
      end

      receipt = current_user.reply_to_conversation(@conversation, @message.body, nil, true, true, @message.attachment)
    else
      recipient = User.find(recipient_id)
      receipt = current_user.send_message([recipient], @message.body, @message.subject, true, @message.attachment)
      @conversation = receipt.notification.conversation

      return render_new_with(recipient, receipt) unless receipt.valid?
    end
    flash.now[:notice] = I18n.t "mailboxer.notifications.sent" 
    redirect_to mailboxer_message_path(@conversation)
  end

  # GET /messages/:ID
  # GET /message/show/:ID/subject/SUBJECT
  def show
    # TODO: refactor this 
    @conversation = Mailboxer::Conversation.find_by_id(params[:id])
    #@conversation = conversations.find(params[:id])
    raise ActiveRecord::RecordNotFound if @conversation.nil?
    # FIXME: ACL should be on app/models/ability.rb
    unless @conversation.is_participant?(current_user) or current_user.admin?
      flash[:alert] = I18n.t('nlt.permission_denied')
      return redirect_to root_path
    end
    @message = Mailboxer::Message.new conversation_id: @conversation.id
    current_user.mark_as_read(@conversation)
  end

  def move
    mailbox = params[:mailbox]
    conversation = conversations.find(params[:id])
    if conversation
      current_user.send(mailbox, conversation)
      flash[:notice] = I18n.t "mailboxer.notifications.sent", mailbox: mailbox
    else
      conversation = conversations.find(params[:conversations])
      conversations.each { |c| current_user.send(mailbox, c) }
      flash[:notice] = I18n.t "mailboxer.notifications.sent", mailbox: mailbox
    end
    redirect_to mailboxer_messages_path(box: params[:current_box])
  end

  def trash
    conversation = conversations.find(params[:id] || params[:conversations])
    current_user.trash(conversation)
    flash[:notice] = I18n.t "mailboxer.notifications.trash"
    redirect_to mailboxer_messages_path(:box => 'inbox')
  end

  def untrash
    conversation = conversations.find(params[:id])
    current_user.untrash(conversation)
    flash[:notice] = I18n.t "mailboxer.notifications.untrash"
    redirect_to mailboxer_messages_path(:box => 'inbox')
  end

  def search
    @search = params[:search]
    @conversations = current_user.search_messages(@search)
    render :index
  end

  private 
  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:mailboxer_message).permit(:conversation_id, :body, :subject, :recipients, :sender_id)
  end

  def recipient_id
    params[:mailboxer_message][:recipients].to_i
  end

  def render_show_with(recipient)
    @message.recipients = recipient.id
    render :show
  end

  def render_new_with(recipient, receipt)
    missing_subject = receipt.errors['notification.conversation.subject'].first
    missing_body = receipt.errors['notification.body'].first
    @message.errors.add(:subject, missing_subject) if missing_subject
    @message.errors.add(:body, missing_body) if missing_body
    @recipient = recipient
    @message.recipients = @recipient.id
    render :new
  end

  def conversations
    current_user.mailbox.conversations
  end

  def interlocutor(conversation)
    conversation.recipients.find { |u| u != current_user }
  end

  helper_method :interlocutor
end
