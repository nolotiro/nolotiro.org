# frozen_string_literal: true
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = conversations.includes(:receipts)
                                  .paginate(page: params[:page])
  end

  def new
    @interlocutor = User.find(params[:recipient_id])
    @message = Message.new(recipients: [@interlocutor])
  end

  def create
    @interlocutor = User.find(params[:recipient_id])
    @conversation = Conversation.new(subject: params[:subject])

    @message = @conversation.messages.build message_params
    @message.deliver

    if @message.valid?
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

    @message = @conversation.messages.build message_params
    @message.deliver(true)

    if @message.valid?
      @conversation.receipts.update_all(trashed: false)

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

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    { sender: current_user, body: params[:body], recipients: [@interlocutor] }
  end

  def setup_errors
    missing_subject = @message.errors['conversation.subject']

    @message.errors.add(:subject, missing_subject.first) if missing_subject.any?
  end

  def conversations
    current_user.conversations
  end
end
