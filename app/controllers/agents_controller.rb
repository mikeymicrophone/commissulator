class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy]

  def index
    @agents = case params[:filtered_attribute]
    when 'avatar_id'
      Avatar.find(params[:filter_value]).agents
    when nil
      Agent.all
    else
      Agent.where params[:filtered_attribute] => params[:filter_value]
    end
    @agents = case params[:sort]
    when nil
      @agents.all
    else
      @agents.order params[:sort]
    end.page params[:page]
  end

  def show
    @google_auth_uri = Agent.google_auth_uri
    @microsoft_auth_uri = Agent.microsoft_auth_uri
  end

  def new
    @agent = Agent.new
  end

  def edit
  end

  def create
    @agent = Agent.new agent_params

    respond_to do |format|
      if @agent.save
        format.js
        format.html { redirect_to @agent, notice: 'Agent was successfully created.' }
        format.json { render :show, status: :created, location: @agent }
      else
        format.html { render :new }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @agent.update agent_params
        format.js
        format.html { redirect_to @agent, notice: 'Agent was successfully updated.' }
        format.json { render :show, status: :ok, location: @agent }
      else
        format.html { render :edit }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to agents_url, notice: 'Agent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_agent
      @agent = Agent.find params[:id]
    end

    def agent_params
      params.require(:agent).permit(:first_name, :last_name, :phone_number, :email, :status, :rate, :payable_first_name, :payable_last_name, :avatar_id)
    end
end
