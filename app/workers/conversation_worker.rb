# frozen_string_literal: true

class ConversationWorker
  include Sidekiq::Worker

  def perform(conversation_id)
    conversation = Conversation.find(conversation_id)

    originator_id = conversation.originator.try(:id)
    recipient_id = conversation.recipient.try(:id)

    conversation.update_column(:originator_id, originator_id)
    conversation.update_column(:recipient_id, recipient_id)
  end
end
