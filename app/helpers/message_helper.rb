module MessageHelper

  def interlocutor( current_user, c )
    if c.recipients and c.recipients.first and c.recipients.second 
      sender = c.recipients.first
      reciever = c.recipients.second
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

