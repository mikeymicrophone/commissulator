class EmployersController < ApplicationController
  before_action :set_employer, only: [:show, :edit, :update, :destroy]

  def index
    @employers = case params[:filtered_attribute]
    when 'industry_id'
      Industry.find(params[:filter_value]).employers
    when nil
      Employer.all
    else
      Employer.where params[:filtered_attribute] => params[:filter_value]
    end
    @employers = case params[:sort]
    when 'name'
      @employers.order :name
    else
      @employers
    end.page params[:page]
  end

  def show
  end

  def new
    @employer = Employer.new
  end

  def edit
  end

  def create
    @employer = Employer.new(employer_params)

    respond_to do |format|
      if @employer.save
        format.html { redirect_to @employer, notice: 'Employer was successfully created.' }
        format.json { render :show, status: :created, location: @employer }
      else
        format.html { render :new }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employer.update(employer_params)
        format.html { redirect_to @employer, notice: 'Employer was successfully updated.' }
        format.json { render :show, status: :ok, location: @employer }
      else
        format.html { render :edit }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employer.destroy
    respond_to do |format|
      format.html { redirect_to employers_url, notice: 'Employer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_employer
      @employer = Employer.find(params[:id])
    end

    def employer_params
      params.require(:employer).permit(:name, :address, :url)
    end
end
