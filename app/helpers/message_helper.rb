# frozen_string_literal: true

module MessageHelper
  def link_to_interlocutor(c)
    interlocutor = c.interlocutor(current_user)
    return '[borrado]' unless interlocutor

    username = interlocutor.username
    link_to username, profile_path(username)
  end
end
