module MessageHelper

  def other_username( current_user, m )
    sender = m.messages.first.recipients.first.username
    reciever = m.messages.first.recipients.second.username
    if current_user == sender
      reciever
    else
      sender
    end
  end

end

