# frozen_string_literal: true

module MessageHelper
  def link_to_interlocutor(conversation)
    user = conversation.interlocutor(current_user)
    return '[borrado]' unless user

    username = user.username
    link_to username, profile_path(username)
  end

  def linked_conversation_title(conversation)
    conversation_header(link_to_interlocutor(conversation),
                        conversation.subject)
  end

  def unlinked_conversation_title(conversation)
    conversation_header(conversation.interlocutor(current_user),
                        conversation.subject)
  end

  private

  def conversation_header(user, subject)
    t('conversations.show.title_html', recipient: user, subject: subject)
  end
end
