module MessageHelper

  def interlocutor( current_user, c )
    other_user = c.recipients.find { |u| u != current_user }
    return "[borrado]" unless other_user

    other_user
  end

end

