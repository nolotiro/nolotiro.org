# frozen_string_literal: true

namespace :users do
  desc 'Renames users with email-like usernames'
  task remove_email_like_usernames: :environment do
    target = User.where("username REGEXP '[^@]+@[^@]+'")

    STDOUT.print "About to rename #{target.size} users. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.find_each do |user|
      sanitized_username = user.username.gsub(/@.*/, '')

      new_username = if User.exists?(username: sanitized_username)
                       sanitized_username + '0'
                     else
                       sanitized_username
                     end

      user.update!(username: new_username)
    end
  end
end
