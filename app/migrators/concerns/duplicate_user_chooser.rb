#
# Chooses the user that will stay in DB from a series of users
#
class DuplicateUserChooser
  def initialize(users)
    @users = users
  end

  def choose
    user = latest_sign_in ||
           latest_published_ad ||
           latest_confirmation ||
           latest_confirmation_sent
    abort unless user

    user.id
  end

  private

  def latest_sign_in
    latest_by(:current_sign_in_at) || latest_by(:last_sign_in_at)
  end

  def latest_published_ad
    @users.joins(:ads).order('ads.published_at').last
  end

  def latest_confirmation
    latest_by(:confirmed_at)
  end

  def latest_confirmation_sent
    latest_by(:confirmation_sent_at)
  end

  def latest_by(column)
    @users.where.not(column => nil).order(column => :asc).last
  end
end
