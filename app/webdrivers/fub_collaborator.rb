class FubCollaborator
  extend Memoist
  
  AGENT_SELECTOR_CLASSNAME = '.sc-bkypNX.esyrIP'
  
  def browser
    Watir::Browser.new :chrome#, :headless => true
  end
  memoize :browser
  
  def add_collaborator agent, client
    browser.goto client.fub_url
    
    collabutton = browser.button 'data-fub-id' => 'SidebarSectionAdd-collaborators'
    collabutton.click
    
    agent_label = browser.label 'class' => 'CollaboratorItem Checkbox'
    agent_activator = agent_label.div 'title' => agent.name # could check if agent is already collaborator
    agent_activator.click
    browser.button('data-fub-id' => 'SimpleModal-save').click
    browser
  end
  
  def store_cookie
    browser.goto 'https://login.followupboss.com/login'
    if Rails.env.production?
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:login_password]
    else
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:staging_login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:staging_login_password]
    end
    browser.form(:id => 'form').submit
    
    sleep 2
    
    browser.goto domain
    
    browser.cookies.to_a.each do |cookie_hash|
      browser.cookies.delete(cookie_hash[:name]) unless cookie_hash[:name] == 'rdack2'
    end
    
    browser.cookies.save cookie_filename
    # cookies = Hash.new
    # browser.cookies.to_a.each do |cookie|
    #   cookies[cookie[:name]] = cookie
    # end
    
    # Sekrets.write(cookie_filename.dirname, cookies.to_yaml, ENV['COOKIE_ENCRYPTION_KEY'])
  end
  
  def load_cookie
    browser.goto domain
    browser.cookies.load cookie_filename
  end
  
  def cookie_filename
    file = if Rails.env.production?
      'follow_up_boss_cookie_admin_commissulator.yml'
    else
      'follow_up_boss_cookie_admin_staging.yml'
    end
    Rails.root.join 'config', 'cookies', file
  end
  
  def domain
    if Rails.env.production?
      "#{Rails.application.credentials.follow_up_boss[:subdomain]}.followupboss.com/2/dashboard"
    else
      "#{Rails.application.credentials.follow_up_boss[:staging_subdomain]}.followupboss.com/2/dashboard"
    end
  end
end
