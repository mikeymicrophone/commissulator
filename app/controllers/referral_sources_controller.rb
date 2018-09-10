class ReferralSourcesController < ApplicationController
  before_action :set_referral_source, only: [:show, :edit, :update, :destroy]

  def index
    @referral_sources = ReferralSource.page params[:page]
  end

  def show
  end

  def new
    @referral_source = ReferralSource.new
  end

  def edit
  end

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

  def destroy
    @referral_source.destroy
    respond_to do |format|
      format.html { redirect_to referral_sources_url, notice: 'Referral source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_referral_source
      @referral_source = ReferralSource.find(params[:id])
    end

    def referral_source_params
      params.require(:referral_source).permit(:name, :active)
    end
end
