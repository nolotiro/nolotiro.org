class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    end
    # if the user is a real user (non anon)
    unless user.username.nil?
      can :create, Ad
      can [:edit, :update], Ad, :user_owner => user.id 
    end
    can :read, :all

    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
