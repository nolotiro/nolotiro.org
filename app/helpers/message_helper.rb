# frozen_string_literal: true
module MessageHelper
  def interlocutor_username(c)
    other_user = interlocutor(c)

    other_user ? other_user.username : '[borrado]'
  end

  def link_to_interlocutor(c)
    interlocutor = interlocutor(c)
    return '[borrado]' unless interlocutor

    username = interlocutor.username
    link_to username, profile_path(username)
  end
end
