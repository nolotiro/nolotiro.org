# frozen_string_literal: true

namespace :comments do
  desc "Deletes comments made before bumping ads"
  task remove_prior_to_bumps: :environment do
    target = Comment.joins(:ad).where("comments.created_at < ads.published_at")

    STDOUT.print "About to delete #{target.size} comments. Continue? (y/n)"
    abort unless STDIN.gets.chomp == "y"

    target.destroy_all
  end
end
