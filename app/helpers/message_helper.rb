# frozen_string_literal: true
module MessageHelper
  def interlocutor_username
    @interlocutor ? @interlocutor.username : '[borrado]'
  end

  def link_to_interlocutor(c)
    interlocutor = c.interlocutor(current_user)
    return '[borrado]' unless interlocutor

    username = interlocutor.username
    link_to username, profile_path(username)
  end
end
