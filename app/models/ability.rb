class Ability
  include CanCan::Ability

  def initialize avatar
    if avatar
      can :manage, :all
      cannot :manage, Commission do |commission|
        !commission.agents.include? avatar.agent
      end
    end
    
    if avatar.admin?
      can :manage, :all
    end
  end
end
