class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :pick_status_of, :update, :destroy]

  def index
    @deals = if params[:filtered_attribute]
      Deal.where :agent_id => params[:filter_value]
    else
      Deal.all
    end
    @deals = case params[:sort]
    when 'commission'
      @deals.order 'commission desc'
    when 'agent'
      @deals.order 'agent_id'
    when 'address'
      @deals.order 'address nulls last'
    when 'unit_number'
      @deals.order 'unit_number nulls last'
    when 'status'
      @deals.order :status
    when 'updated_at'
      @deals.order 'updated_at desc'
    else
      @deals
    end.page params[:page]
  end

  def show
  end

  def new
    @deal = Deal.new
  end

  def edit
  end
  
  def pick_status_of
  end

  def create
    @deal = Deal.new deal_params
    @deal.agent = current_agent

    respond_to do |format|
      if @deal.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @deal.update deal_params
        format.js
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to deals_url, notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def fabricate
    @deal = case params[:status]
    when 'underway'
      Fabricate :underway_deal
    when 'completed'
      Fabricate :completed_deal
    end
  end

  private
    def set_deal
      @deal = Deal.find params[:id]
    end

    def deal_params
      params.require(:deal).permit :name, :address, :unit_number, :status, :commission
    end
end
