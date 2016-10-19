# frozen_string_literal: true

module MessageHelper
  def link_to_profile(user)
    return '[borrado]' unless user

    username = user.username
    link_to username, profile_path(username)
  end
end
