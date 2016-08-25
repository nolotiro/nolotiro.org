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

  desc 'Renames users with id-like usernames'
  task remove_id_like_usernames: :environment do
    target = User.where("username REGEXP '^[1-9]+$'")

    STDOUT.print "About to rename #{target.size} users. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.find_each do |user|
      user.update!(username: user.email.gsub(/@.*/, '') + user.username)
    end
  end

  desc 'Removes ads by locked users'
  task remove_spam_leftovers: :environment do
    target = Ad.joins(:user).where(users: { locked: 1 })

    STDOUT.print "About to remove #{target.size} ads. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.destroy_all
  end
end
