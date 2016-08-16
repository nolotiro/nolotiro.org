# frozen_string_literal: true
class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_conversation, only: [:show, :update]

  def index
    @conversations = conversations.order(updated_at: :desc)
                                  .paginate(page: params[:page])
  end

  def new
    @interlocutor = User.find(params[:recipient_id])
    @conversation = Conversation.start(start_params)
    @message = @conversation.messages.first

    authorize(@conversation)
  end

  def create
    @interlocutor = User.find(params[:recipient_id])
    @conversation = Conversation.start(start_params)
    @message = @conversation.messages.first

    authorize(@conversation)

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
    @interlocutor = @conversation.interlocutor(current_user)
    @message = @conversation.reply(reply_params)

    authorize(@conversation)

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
    authorize(@conversation)

    @interlocutor = @conversation.interlocutor(current_user)

    @message = @conversation.reply(reply_params)

    @conversation.mark_as_read(current_user)
  end

  def trash
    conversation = conversations.find(params[:id] || params[:conversations])
    Array(conversation).each { |c| c.move_to_trash(current_user) }

    redirect_to conversations_path,
                notice: I18n.t('mailboxer.notifications.trash')
  end

  private

  def load_conversation
    @conversation = conversations.find(params[:id])
  end

  def start_params
    reply_params.merge(subject: params[:subject])
  end

  def reply_params
    { sender: current_user, body: params[:body], recipient: @interlocutor }
  end

  def setup_errors
    missing_subject = @conversation.errors['subject']

    @message.errors.add(:subject, missing_subject.first) if missing_subject.any?
  end

  def conversations
    Conversation.involving(current_user)
  end
end
