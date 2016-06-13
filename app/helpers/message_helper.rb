module MessageHelper

  def other_username( current_user, m )
    if m.recipients and m.recipients.first and m.recipients.second 
      sender = m.recipients.first
      reciever = m.recipients.second
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

