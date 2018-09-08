class ReferralSourcesController < ApplicationController
  before_action :set_referral_source, only: [:show, :edit, :update, :destroy]

  # GET /referral_sources
  # GET /referral_sources.json
  def index
    @referral_sources = ReferralSource.all
  end

  # GET /referral_sources/1
  # GET /referral_sources/1.json
  def show
  end

  # GET /referral_sources/new
  def new
    @referral_source = ReferralSource.new
  end

  # GET /referral_sources/1/edit
  def edit
  end

  # POST /referral_sources
  # POST /referral_sources.json
  def create
    @referral_source = ReferralSource.new(referral_source_params)

    respond_to do |format|
      if @referral_source.save
        format.html { redirect_to @referral_source, notice: 'Referral source was successfully created.' }
        format.json { render :show, status: :created, location: @referral_source }
      else
        format.html { render :new }
        format.json { render json: @referral_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /referral_sources/1
  # PATCH/PUT /referral_sources/1.json
  def update
    respond_to do |format|
      if @referral_source.update(referral_source_params)
        format.html { redirect_to @referral_source, notice: 'Referral source was successfully updated.' }
        format.json { render :show, status: :ok, location: @referral_source }
      else
        format.html { render :edit }
        format.json { render json: @referral_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /referral_sources/1
  # DELETE /referral_sources/1.json
  def destroy
    @referral_source.destroy
    respond_to do |format|
      format.html { redirect_to referral_sources_url, notice: 'Referral source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_referral_source
      @referral_source = ReferralSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def referral_source_params
      params.require(:referral_source).permit(:name, :active)
    end
end
