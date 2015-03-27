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
      can :create, Mailboxer::Message
      # FIXME: not working on messages_controller.rb
      #can :create, :show, Conversation do |conversation|
      #  conversation.is_participant? user
      #end
      can :list, Mailboxer::Message, :user_from => user.id
      can :list, Mailboxer::Message, :user_to => user.id
      cannot :lock, Admin
      cannot :unlock, Admin
      cannot :become, Admin
      can [:edit, :update], Ad, :user_owner => user.id 
    end
    can :read, :all
  end

end
