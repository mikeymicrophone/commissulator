class FubCollaborator < FubAuthenticated
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
end
