class AssistantsController < ApplicationController
  before_action :set_assistant, only: [:show, :edit, :update, :destroy]

  def index
    @assistants = case params[:sort]
    when 'first_name'
      Assistant.order :first_name
    when 'last_name'
      Assistant.order :last_name
    else
      Assistant.all
    end.page params[:page]
  end

  def show
  end

  def new
    @assistant = Assistant.new
  end

  def edit
  end

  def create
    @assistant = Assistant.new assistant_params

    respond_to do |format|
      if @assistant.save
        format.js
        format.html { redirect_to @assistant, notice: 'Assistant was successfully created.' }
        format.json { render :show, status: :created, location: @assistant }
      else
        format.html { render :new }
        format.json { render json: @assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @assistant.update assistant_params
        format.js
        format.html { redirect_to @assistant, notice: 'Assistant was successfully updated.' }
        format.json { render :show, status: :ok, location: @assistant }
      else
        format.html { render :edit }
        format.json { render json: @assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assistant.destroy
    respond_to do |format|
      format.html { redirect_to assistants_url, notice: 'Assistant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_assistant
      @assistant = Assistant.find params[:id]
    end

    def assistant_params
      params.require(:assistant).permit(:first_name, :last_name, :phone_number, :email, :status, :rate)
    end
end
