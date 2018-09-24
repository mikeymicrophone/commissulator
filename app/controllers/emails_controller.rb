class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  def index
    @emails = case params[:filtered_attribute]
    when 'industry_id'
      Industry.find(params[:filter_value]).emails
    when nil
      Email.all
    else
      Email.where params[:filtered_attribute] => params[:filter_value]
    end.page params[:page]
  end

  def show
  end

  def new
    @email = Email.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_email
      @email = Email.find(params[:id])
    end

    def email_params
      params.require(:email).permit(:variety, :address, :client_id, :employer_id)
    end
end
