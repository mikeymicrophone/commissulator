class CalendarEventsController < ApplicationController
  before_action :set_calendar_event, only: [:show, :edit, :update, :destroy]

  def index
    @calendar_events = CalendarEvent.all
  end

  def show
  end

  def new
    @calendar_event = CalendarEvent.new
  end

  def edit
  end

  def create
    @calendar_event = CalendarEvent.new calendar_event_params

    respond_to do |format|
      if @calendar_event.save
        format.html { redirect_to @calendar_event, notice: 'Calendar event was successfully created.' }
        format.json { render :show, status: :created, location: @calendar_event }
      else
        format.html { render :new }
        format.json { render json: @calendar_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @calendar_event.update calendar_event_params
        format.html { redirect_to @calendar_event, notice: 'Calendar event was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar_event }
      else
        format.html { render :edit }
        format.json { render json: @calendar_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @calendar_event.destroy
    respond_to do |format|
      format.html { redirect_to calendar_events_url, notice: 'Calendar event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def token
    @agent = current_avatar.agent
    auth = {'code' => params[:code], 'scope' => params[:scope]}
    
    File.open(Rails.root.join('tmp', 'google_auth_code.json'), 'w+') do |file|
      file.write auth.to_json
    end
    
    @agent.cookies.attach :io => File.open(Rails.root.join('tmp', 'google_auth_code.json')), :filename => 'google_auth_code.json'
    @agent.fetch_google_access_tokens
    redirect_to @agent, :notice => 'Token secured.'
  end

  private
    def set_calendar_event
      @calendar_event = CalendarEvent.find params[:id]
    end

    def calendar_event_params
      params.require(:calendar_event).permit :title, :description, :start_time, :end_time, :invitees, :location, :follow_up_boss_id, :google_id, :calendly_id, :agent_id, :confirmed_at
    end
end
