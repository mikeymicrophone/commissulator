class AssistsController < ApplicationController
  before_action :set_assist, only: [:show, :edit, :update, :destroy]

  def index
    @assists = if params[:filtered_attribute]
      Assist.where params[:filtered_attribute] => params[:filter_value]
    else
      Assist.all
    end
    @assists = case params[:sort]
    when 'updated_at'
      @assists.order 'updated_at desc'
    when 'deal_id'
      @assists.order 'deal_id desc'
    when 'agent_id'
      @assists.order 'agent_id desc'
    when 'payout'
      Kaminari.paginate_array(@assists.sort_by { |assist| assist.payout.to_d }.reverse )
    else
      @assists
    end.page params[:page]
  end

  def show
  end

  def new
    @assist = Assist.new
  end

  def edit
  end

  def create
    @assist = Assist.new assist_params

    respond_to do |format|
      if @assist.save
        format.js
        format.html { redirect_to @assist, notice: 'Assist was successfully created.' }
        format.json { render :show, status: :created, location: @assist }
      else
        format.html { render :new }
        format.json { render json: @assist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @assist.update assist_params
        format.html { redirect_to @assist, notice: 'Assist was successfully updated.' }
        format.json { render :show, status: :ok, location: @assist }
      else
        format.html { render :edit }
        format.json { render json: @assist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assist.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to assists_url, notice: 'Assist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_assist
      @assist = Assist.find(params[:id])
    end

    def assist_params
      params.require(:assist).permit :deal_id, :agent_id, :role_id, :status, :rate, :adjustment, :expense
    end
end
