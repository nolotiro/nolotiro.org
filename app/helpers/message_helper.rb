# frozen_string_literal: true

module MessageHelper
  def link_to_interlocutor(conversation)
    user = conversation.interlocutor(current_user)
    return '[borrado]' unless user

    username = user.username
    link_to username, profile_path(username)
  end

  def interlocutor_name(conversation)
    user = conversation.interlocutor(current_user)
    return '[borrado]' unless user

    user.username
  end

  def linked_conversation_title(conversation)
    conversation_header(link_to_interlocutor(conversation),
                        conversation.subject)
  end

  def unlinked_conversation_title(conversation)
    conversation_header(interlocutor_name(conversation), conversation.subject)
  end

  def bubble_edge_css_class(message)
    message.sender == current_user ? 'triangle-me' : 'triangle-other'
  end

  def bubble_css_classes(message)
    message.sender == current_user ? 'bubble bg-bubble-me' : 'bubble'
  end

  private

  def conversation_header(user, subject)
    t('conversations.show.title_html', recipient: user, subject: subject)
  end
end
