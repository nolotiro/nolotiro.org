# frozen_string_literal: true

class ConversationUrlRewriter
  def call(_params, request)
    request.fullpath.sub(%r{\A(/[a-z][a-z])?/messages}, '\1/conversations')
  end
end
