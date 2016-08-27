# frozen_string_literal: true

namespace :users do
  desc 'Removes ads by locked users'
  task remove_spam_leftovers: :environment do
    target = Ad.joins(:user).where(users: { locked: 1 })

    STDOUT.print "About to remove #{target.size} ads. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.destroy_all
  end
end
