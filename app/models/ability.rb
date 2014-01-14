class Ability
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :manage, Resque
      can :lock, Admin
      can :unlock, Admin
      can :become, Admin
    end
    # if the user is a real user (non anon)
    unless user.username.nil?
      can :create, Ad
      can :create, Comment
      can :create, Message
      can :list, Message
      cannot :lock, Admin
      cannot :unlock, Admin
      cannot :become, Admin
      can [:edit, :update], Ad, :user_owner => user.id 
    end
    can :read, :all
  end

end
