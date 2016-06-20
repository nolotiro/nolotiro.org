# frozen_string_literal: true

require 'ruby-progressbar'

#
# Takes care of removing duplicated usernames
#
class DuplicateUsernameFixer
  def initialize(username)
    @username = username
  end

  def self.fix!
    duplicated_usernames = User.group('LOWER(username)')
                               .having('COUNT(*) > 1')
                               .pluck('LOWER(username)')

    bar = ProgressBar.create(total: duplicated_usernames.size,
                             format: '%a %B %c/%C')

    duplicated_usernames.each do |username|
      new(username).fix!

      bar.increment
    end
  end

  def fix!
    users.each.with_index do |user, index|
      user.update!(username: free_username(@username, index))
    end
  end

  private

  def free_username(basename, index)
    current_index = index

    loop do
      username = "#{basename}#{current_index}"

      return username unless User.exists?(username: username)

      current_index = rand(2017)
    end
  end

  def users
    @users ||= User.where("LOWER(username) = '#{@username}'")
  end
end
