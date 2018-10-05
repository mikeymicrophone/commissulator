class FubCollaborator
  def add_collaborator agent, client
    browser = Watir::Browser.start 'https://login.followupboss.com/login'
    if Rails.env.production?
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:login_password]
    else
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:staging_login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:staging_login_password]
    end
    browser.form(:id => 'form').submit
    
    sleep 2
    
    browser.goto client.fub_url
    
    collabutton = browser.button 'data-fub-id' => 'SidebarSectionAdd-collaborators'
    collabutton.click
    
    agent_label = browser.label 'class' => 'CollaboratorItem Checkbox'
    agent_activator = agent_label.div 'title' => agent.name # could check if agent is already collaborator
    agent_activator.click
    browser.button('data-fub-id' => 'SimpleModal-save').click
    browser
  end
end
