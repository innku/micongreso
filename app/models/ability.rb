class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify
    
    if user
      if user.admin?
        can :manage, :all
      elsif user.citizen?
        can :read, Member
        can :create, Message
        can :read, News
        can :create, Comment
        can :create, Vote
        can :update, User do |u|
          u == user
        end
        can :create, Contact
      end
    end
  end
  
end