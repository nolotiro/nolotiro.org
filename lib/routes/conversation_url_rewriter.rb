# frozen_string_literal: true

class ConversationUrlRewriter
  def call(_params, request)
    path = request.fullpath

    if path =~ old_messages_pattern
      path.sub(old_messages_pattern, '\1/conversations')
    elsif path =~ ancient_new_message_pattern
      path.sub(ancient_new_message_pattern,
               '\1/conversations/new?recipient_id=\2&subject=')
    end
  end

  private

  def old_messages_pattern
    %r{\A(/[a-z][a-z])?/messages}
  end

  def ancient_new_message_pattern
    %r{\A(/[a-z][a-z])?/message/create/id_user_to/(\d+)/subject/}
  end
end
