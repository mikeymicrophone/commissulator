class EmploymentsController < ApplicationController
  before_action :set_employment, only: [:show, :edit, :update, :destroy]

  def index
    @employments = case params[:filtered_attribute]
    when 'registration_id'
      Registration.find(params[:filter_value]).employments
    when 'industry_id'
      Industry.find(params[:filter_value]).employments
    when nil
      Employment.all
    else
      Employment.where params[:filtered_attribute] => params[:filter_value]
    end.page params[:page]
  end

  def show
  end

  def new
    @employment = Employment.new
  end

  def edit
  end

  def create
    @employment = Employment.new(employment_params)

    respond_to do |format|
      if @employment.save
        format.html { redirect_to @employment, notice: 'Employment was successfully created.' }
        format.json { render :show, status: :created, location: @employment }
      else
        format.html { render :new }
        format.json { render json: @employment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employment.update(employment_params)
        format.html { redirect_to @employment, notice: 'Employment was successfully updated.' }
        format.json { render :show, status: :ok, location: @employment }
      else
        format.html { render :edit }
        format.json { render json: @employment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employment.destroy
    respond_to do |format|
      format.html { redirect_to employments_url, notice: 'Employment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_employment
      @employment = Employment.find(params[:id])
    end

    def employment_params
      params.require(:employment).permit(:position, :income, :start_date, :client_id, :employer_id)
    end
end
