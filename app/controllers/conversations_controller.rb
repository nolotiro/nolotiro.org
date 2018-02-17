# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_conversation, only: %i[show update]

  def index
    @conversations =
      policy_scope(Conversation).includes(:originator, :recipient)
                                .order(updated_at: :desc)
                                .page(params[:page])

    @unread_counts = Message.where(conversation_id: @conversations.map(&:id))
                            .unread_by(current_user)
                            .group(:conversation_id)
                            .size
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
                  notice: I18n.t("conversations.notifications.sent")
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
                  notice: I18n.t("conversations.notifications.sent")
    else
      render :show
    end
  end

  def show
    authorize(@conversation)

    @interlocutor = @conversation.interlocutor(current_user)

    @message = @conversation.reply(reply_params)

    @conversation.mark_as_read(current_user)
  end

  def trash
    conversation =
      policy_scope(Conversation).find(params[:id] || params[:conversations])

    Array(conversation).each { |c| c.move_to_trash(current_user) }

    redirect_to conversations_path,
                notice: I18n.t("conversations.notifications.trash")
  end

  private

  def load_conversation
    @conversation = Conversation.find(params[:id])
  end

  def start_params
    reply_params.merge(subject: params[:subject])
  end

  def reply_params
    { sender: current_user, body: params[:body], recipient: @interlocutor }
  end

  def setup_errors
    missing_subject = @conversation.errors["subject"]

    @message.errors.add(:subject, missing_subject.first) if missing_subject.any?
  end
end
