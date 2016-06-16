module MessageHelper

  def interlocutor( c )
    c.recipients.find { |u| u != current_user }
  end

  def interlocutor_username(c)
    interlocutor = interlocutor(c)

    interlocutor ? interlocutor.username : '[borrado]'
  end

  def link_to_interlocutor(c)
    interlocutor = interlocutor(c)
    return '[borrado]' unless interlocutor

    username = interlocutor.username
    link_to username, profile_path(username)
  end
end

