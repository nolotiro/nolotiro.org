# frozen_string_literal: true

#
# Chooses the user that will stay in DB from a series of users
#
class DuplicateUserChooser
  def initialize(users)
    @users = users
  end

  def master
    @master ||=
      last_visitor || last_publisher || last_confirmed || last_registered
  end

  def duplicates
    @duplicates ||= @users.where.not(id: master.id)
  end

  private

  def last_visitor
    latest_by(:current_sign_in_at) || latest_by(:last_sign_in_at)
  end

  def last_publisher
    @users.joins(:ads).order('ads.published_at').last
  end

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
