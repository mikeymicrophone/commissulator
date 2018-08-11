class AgentsController < ApplicationController
  before_action :set_agent
  
  def edit
  end
  
  def update
    @agent.update agent_params
    redirect_to deals_path
  end
  
  private
  def set_agent
    @agent = current_agent
  end
  
  def agent_params
    params.require(:agent).permit(:first_name, :last_name, :phone_number)
  end
end
