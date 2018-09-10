module AvatarsHelper
  def avatar_new_registration_path avatar
    link_to 'Register Client', begin_registration_path(:avatar_id => avatar)
  end
  
  def weekly_deals_by avatar
    link_to "(#{avatar.deals.this_week.count} this week)", deals_path(:filtered_attribute => :avatar_id, :filter_value => avatar, :cutoff => 1.week.ago)
  end
  
  def deals_by avatar
    link_to pluralize(avatar.deals.count, 'Deal'), deals_path(:filtered_attribute => :avatar_id, :filter_value => avatar)
  end
  
  def commissions_for avatar
    link_to pluralize(avatar.commissions.count, 'Commission'), commissions_path(:filtered_attribute => :avatar_id, :filter_value => avatar)
  end
  
  def agents_of avatar
    link_to pluralize(avatar.agents.count, 'Agent'), agents_path(:filtered_attribute => :avatar_id, :filter_value => avatar)
  end
end
