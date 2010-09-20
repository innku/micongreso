class AdminAbility
  include CanCan::Ability
  
  def initialize(user)
    alias_action :update, :destroy, :to => :modify
        
    can :manage, :all if user && user.admin?
  end
  
end