# frozen_string_literal: true

#
# Chooses a user from a series of users
#
class UserChooser
  def initialize(users)
    @users = users
  end

  def master
    raise NotImplementedError, 'Implement your criteria in the subclass'
  end

  def duplicates
    @duplicates ||= @users.where.not(id: master.id)
  end

  private

  def last_confirmed
    latest_by(:confirmed_at)
  end

  def last_registered
    latest_by(:confirmation_sent_at)
  end

  def latest_by(column)
    @users.where.not(column => nil).order(column => :asc).last
  end
end
