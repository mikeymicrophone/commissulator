class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  def index
    @participants = if params[:filtered_attribute]
      Participant.where params[:filtered_attribute] => params[:filter_value]
    else
      Participant.all
    end
    @participants = case params[:sort]
    when 'updated_at'
      @participants.order 'updated_at desc'
    when 'deal_id'
      @participants.order 'deal_id desc'
    when 'assistant_id'
      @participants.order 'assistant_id desc'
    when 'payout'
      Kaminari.paginate_array(@participants.sort_by { |participant| participant.payout }.reverse )
    else
      @participants
    end.page params[:page]
  end

  def show
  end

  def new
    @participant = Participant.new
  end

  def edit
  end

  def create
    @participant = Participant.new participant_params

    respond_to do |format|
      if @participant.save
        format.js
        format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @participant.update participant_params
        format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @participant.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def participant_params
      params.require(:participant).permit :deal_id, :assistant_id, :role, :status, :rate, :adjustment
    end
end
