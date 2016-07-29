# frozen_string_literal: true

require 'choosers/user_chooser'

#
# Chooses a user from a series of users with duplicated usernames
#
class DuplicateUsernameUserChooser < UserChooser
  def master
    top_giver ||
      top_taker ||
      most_frequent_visitor ||
      last_confirmed ||
      last_registered
  end

  private

  def top_giver
    @users.joins(:ads)
          .where(ads: { type: 1 })
          .select(:user_owner, 'COUNT(*) as n_presents')
          .group(:user_owner)
          .having('n_presents > 0')
          .order('n_presents DESC')
          .first
  end

  def top_taker
    @users.joins(:ads)
          .where(ads: { type: 2 })
          .select(:user_owner, 'COUNT(*) as n_requests')
          .group(:user_owner)
          .having('n_requests > 0')
          .order('n_requests DESC')
          .first
  end

  def most_frequent_visitor
    @users.where.not(sign_in_count: 0).order(sign_in_count: :desc).first
  end
end
