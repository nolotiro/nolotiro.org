# frozen_string_literal: true
class Ability
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can [:lock, :unlock, :become], Admin
      can :manage, ActiveAdmin
    end
    # if the user is a real user (non anon)
    unless user.username.nil?
      can :create, Ad
      can :create, Comment
      cannot :lock, Admin
      cannot :unlock, Admin
      cannot :become, Admin
      can [:edit, :update, :destroy], Ad, user_owner: user.id
      can(:bump, Ad) { |ad| ad.user_owner == user.id && ad.bumpable? }
      cannot :manage, ActiveAdmin
    end
    can :read, :all
  end
end
