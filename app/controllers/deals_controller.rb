class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :pick_status_of, :update, :destroy]

  def index
    @deals = case params[:sort]
    when 'commission'
      Deal.order 'commission desc'
    when 'agent'
      Deal.order 'agent_id'
    when 'address'
      Deal.order 'address nulls last'
    when 'unit_number'
      Deal.order 'unit_number nulls last'
    when 'status'
      Deal.order :status
    when 'updated_at'
      Deal.order 'updated_at desc'
    else
      Deal.all
    end
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

  private
    def set_deal
      @deal = Deal.find params[:id]
    end

    def deal_params
      params.require(:deal).permit :name, :address, :unit_number, :status, :commission
    end
end
