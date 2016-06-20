# frozen_string_literal: true

#
# Renames users with duplicated usernames
#
class UserRenamer
  def initialize(user)
    @user = user
  end

  def rename!
    @user.update!(username: replacement)
  end

  private

  def email_id
    @email_id ||= @user.email.split('@')[0]
  end

  def replacement
    n = 0

    loop do
      username = n == 0 ? email_id : "#{email_id}#{n}"
      return username unless User.exists?(username: username)

      n += 1
    end
  end
end
