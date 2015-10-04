module MessageHelper

  def other_username( current_user, m )
    if m.messages.first and m.messages.first.recipients.first and m.messages.first.recipients.second 
      sender = m.messages.first.recipients.first.username
      reciever = m.messages.first.recipients.second.username
      if current_user == sender
        reciever
      else
        sender
      end
    else 
      "[borrado]"
    end
  end

end

