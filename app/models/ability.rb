class Ability
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :manage, Resque
    end
    # if the user is a real user (non anon)
    unless user.username.nil?
      can :create, Ad
      # TODO cannot become another user
      # TODO cannot lock a user
      # TODO cannot unlock a user
      can [:edit, :update], Ad, :user_owner => user.id 
    end
    can :read, :all
  end

end
