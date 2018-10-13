namespace :cookies do
  desc 'acquire auth cookies for agents to access Follow Up Boss'
  task :refresh_follow_up_boss => :environment do
    Agent.find_each do |agent|
      fub_driver = FubAuthenticated.new
      fub_driver.agent = agent
      fub_driver.login_submit
      fub_driver.store_cookie
    end
  end
end
