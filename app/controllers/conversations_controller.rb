# frozen_string_literal: true
class ConversationsController < ApplicationController
  require 'will_paginate/array'

  before_action :authenticate_user!

  def index
    @conversations = conversations.includes(:receipts)
                                  .sort_by { |c| c.last_message.created_at }
                                  .reverse

    @conversations = @conversations.paginate(page: params[:page], total_entries: @conversations.to_a.size)
  end

  def new
    @interlocutor = User.find(params[:user_id])
    @message = Mailboxer::Message.new(recipients: @interlocutor.id)
  end

  def create
    @interlocutor = User.find(params[:mailboxer_message][:recipients])
    @conversation = Mailboxer::Conversation.new(subject: message_params[:subject])

    @message = @conversation.messages.build message_params.except(:subject)
    @message.deliver

    if @message.valid?
      redirect_to mailboxer_conversation_path(@conversation),
                  notice: I18n.t('mailboxer.notifications.sent')
    else
      setup_errors
      @message.recipients = @interlocutor.id
      render :new
    end
  end

  def update
    @conversation = conversations.find(params[:id])
    @interlocutor = interlocutor(@conversation)

    @message = @conversation.messages.build message_params
    @message.deliver

    if @message.valid?
      @conversation.receipts.untrash

      redirect_to mailboxer_conversation_path(@conversation),
                  notice: I18n.t('mailboxer.notifications.sent')
    else
      @message.recipients = @interlocutor.id
      render :show
    end
  end

  # GET /messages/:ID
  # GET /message/show/:ID/subject/SUBJECT
  def show
    @conversation = conversations.find(params[:id])
    @interlocutor = interlocutor(@conversation)

    @message = Mailboxer::Message.new conversation: @conversation
    current_user.mark_as_read(@conversation)
  end

  def trash
    conversation = conversations.find(params[:id] || params[:conversations])
    current_user.trash(conversation)
    flash[:notice] = I18n.t 'mailboxer.notifications.trash'
    redirect_to mailboxer_conversations_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:mailboxer_message)
          .permit(:body, :subject, :recipients)
          .merge(sender: current_user, recipients: @interlocutor)
  end

  def setup_errors
    missing_subject = @message.errors['conversation.subject']

    @message.errors.add(:subject, missing_subject.first) if missing_subject.any?
  end

  def conversations
    current_user.mailbox.conversations(mailbox_type: 'not_trash')
  end

  def interlocutor(conversation)
    conversation.recipients.find { |u| u != current_user }
  end

  helper_method :interlocutor
end
