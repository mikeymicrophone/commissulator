class Ability
  include CanCan::Ability

  def initialize avatar
    if avatar.simple
      # can :manage, :all
      cannot :activate, Avatar
      # this needs to allow creation of new commissions, and probably editing as well
      # cannot :manage, Commission do |commission|
      #   !commission.agents.include? avatar.agent
      # end
    end
    
    if avatar.admin?
      can :manage, :all
    end

    if avatar.has_role? :assistant
      can :edit, employer
    end
  end
end
