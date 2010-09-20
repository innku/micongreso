class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify
    
    user ||= User.new
    
    if user.admin?
      can :manage, :all
    elsif user.citizen?
      can :create, Message
      can :create, Comment
      can :create, Vote
      can :update, User do |u|
        u == user
      end
      can :read, News
      can :read, Member
      can :create, Contact
      can :deliver, :contacts
    else
      can :read, News
      can :read, Member
      can :create, Contact
      can :deliver, :contacts
    end
    
  end
  
end