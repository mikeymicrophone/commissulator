class Ability
  include CanCan::Ability

  def initialize avatar
    if avatar
      can :manage, :all
      cannot :activate, Avatar
      cannot :edit, Employer
      cannot :destroy, Employer
      # this needs to allow creation of new commissions, and probably editing as well
      # cannot :manage, Commission do |commission|
      #   !commission.agents.include? avatar.agent
      # end
    end
    
    if avatar.admin?
      can :manage, :all
    end
  end
end
