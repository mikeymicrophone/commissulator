class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :display, :card, :edit, :update, :destroy]

  def index
    @registrations = case params[:filtered_attribute]
      
    when nil
      Registration.all
    else
      Registration.where params[:filtered_attribute] => params[:filter_value]
    end
    @registrations = case params[:sort]
    when nil
      @registrations.recent
    else
      @registrations.order params[:sort]
    end.page params[:page]
  end

  def show
  end
  
  def display
    @registrant = @registration.registrants.first
    @first_client = @registrant.client
    @title = "#{@first_client.name} Registration Card"
  end
  
  def card
    
  end

  def new
    @registration = Registration.new
    render :layout => 'empty'
  end

  def edit
  end

  def create
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render :show, status: :created, location: @registration }
      else
        format.html { render :new }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.js
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration }
      else
        format.html { render :edit }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url, notice: 'Registration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def fabricate
    @registration = Fabricate :complete_registration
    @registration.follow_up!
    redirect_to @registration
  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:minimum_price, :maximum_price, :size, :move_by, :reason_for_moving, :occupants, :pets, :referral_source_id, :agent_id, :signature)
    end
end
