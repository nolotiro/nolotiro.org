# frozen_string_literal: true
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = conversations.includes(:receipts)
                                  .paginate(page: params[:page])
  end

  def new
    @interlocutor = User.find(params[:recipient_id])
    @conversation = Conversation.new(subject: params[:subject])
    @message = @conversation.envelope_for sender: current_user,
                                          recipient: @interlocutor
  end

  def create
    @interlocutor = User.find(params[:recipient_id])
    @conversation = Conversation.new(subject: params[:subject])
    @message = @conversation.envelope_for message_params

    if @conversation.save
      @message.deliver

      redirect_to conversation_path(@conversation),
                  notice: I18n.t('mailboxer.notifications.sent')
    else
      setup_errors

      render :new
    end
  end

  def update
    @conversation = conversations.find(params[:id])
    @interlocutor = @conversation.interlocutor(current_user)
    @message = @conversation.envelope_for message_params

    if @conversation.save
      @message.deliver

      redirect_to conversation_path(@conversation),
                  notice: I18n.t('mailboxer.notifications.sent')
    else
      render :show
    end
  end

  # GET /messages/:ID
  # GET /message/show/:ID/subject/SUBJECT
  def show
    @conversation = conversations.find(params[:id])
    @interlocutor = @conversation.interlocutor(current_user)

    @message = @conversation.messages.build
    current_user.mark_as_read(@conversation)
  end

  def trash
    conversation = conversations.find(params[:id] || params[:conversations])
    Array(conversation).each { |c| c.move_to_trash(current_user) }

    redirect_to conversations_path,
                notice: I18n.t('mailboxer.notifications.trash')
  end

  private

  def message_params
    { sender: current_user, body: params[:body], recipient: @interlocutor }
  end

  def setup_errors
    missing_subject = @conversation.errors['subject']

    @message.errors.add(:subject, missing_subject.first) if missing_subject.any?
  end

  def conversations
    current_user.conversations
  end
end
