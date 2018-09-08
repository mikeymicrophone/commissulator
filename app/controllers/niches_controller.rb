class NichesController < ApplicationController
  before_action :set_nich, only: [:show, :edit, :update, :destroy]

  # GET /niches
  # GET /niches.json
  def index
    @niches = Niche.all
  end

  # GET /niches/1
  # GET /niches/1.json
  def show
  end

  # GET /niches/new
  def new
    @nich = Niche.new
  end

  # GET /niches/1/edit
  def edit
  end

  # POST /niches
  # POST /niches.json
  def create
    @nich = Niche.new(nich_params)

    respond_to do |format|
      if @nich.save
        format.html { redirect_to @nich, notice: 'Niche was successfully created.' }
        format.json { render :show, status: :created, location: @nich }
      else
        format.html { render :new }
        format.json { render json: @nich.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /niches/1
  # PATCH/PUT /niches/1.json
  def update
    respond_to do |format|
      if @nich.update(nich_params)
        format.html { redirect_to @nich, notice: 'Niche was successfully updated.' }
        format.json { render :show, status: :ok, location: @nich }
      else
        format.html { render :edit }
        format.json { render json: @nich.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /niches/1
  # DELETE /niches/1.json
  def destroy
    @nich.destroy
    respond_to do |format|
      format.html { redirect_to niches_url, notice: 'Niche was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nich
      @nich = Niche.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nich_params
      params.require(:nich).permit(:employer_id, :industry_id)
    end
end
