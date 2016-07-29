# frozen_string_literal: true

require 'ruby-progressbar'
require 'duplicate_username_user_chooser'
require 'concerns/user_renamer'

#
# Takes care of removing duplicated usernames
#
class DuplicateUsernameMigrator
  def initialize(username)
    @username = username
  end

  def self.migrate!
    duplicated_usernames = User.group('LOWER(username)')
                               .having('COUNT(*) > 1')
                               .pluck('LOWER(username)')

    bar = ProgressBar.create(total: duplicated_usernames.size,
                             format: '%a %B %c/%C')

    duplicated_usernames.each do |username|
      new(username).migrate!

      bar.increment
    end
  end

  def migrate!
    duplicates.each { |user| UserRenamer.new(user).rename! }
  end

  private

  def users
    @users ||= User.where("LOWER(username) = '#{@username}'")
  end

  def duplicates
    DuplicateUsernameUserChooser.new(users).duplicates
  end
end
