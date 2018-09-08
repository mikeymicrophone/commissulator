class RegistrantsController < ApplicationController
  before_action :set_registrant, only: [:show, :edit, :update, :destroy]

  # GET /registrants
  # GET /registrants.json
  def index
    @registrants = Registrant.all
  end

  # GET /registrants/1
  # GET /registrants/1.json
  def show
  end

  # GET /registrants/new
  def new
    @registrant = Registrant.new
  end

  # GET /registrants/1/edit
  def edit
  end

  # POST /registrants
  # POST /registrants.json
  def create
    @registrant = Registrant.new(registrant_params)

    respond_to do |format|
      if @registrant.save
        format.html { redirect_to @registrant, notice: 'Registrant was successfully created.' }
        format.json { render :show, status: :created, location: @registrant }
      else
        format.html { render :new }
        format.json { render json: @registrant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrants/1
  # PATCH/PUT /registrants/1.json
  def update
    respond_to do |format|
      if @registrant.update(registrant_params)
        format.html { redirect_to @registrant, notice: 'Registrant was successfully updated.' }
        format.json { render :show, status: :ok, location: @registrant }
      else
        format.html { render :edit }
        format.json { render json: @registrant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrants/1
  # DELETE /registrants/1.json
  def destroy
    @registrant.destroy
    respond_to do |format|
      format.html { redirect_to registrants_url, notice: 'Registrant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registrant
      @registrant = Registrant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registrant_params
      params.require(:registrant).permit(:other_fund_sources, :client_id, :registration_id)
    end
end
