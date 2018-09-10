class NichesController < ApplicationController
  before_action :set_nich, only: [:show, :edit, :update, :destroy]

  def index
    @niches = Niche.page params[:page]
  end

  def show
  end

  def new
    @niche = Niche.new
  end

  def edit
  end

  def create
    @niche = Niche.new(niche_params)

    respond_to do |format|
      if @niche.save
        format.html { redirect_to @niche, notice: 'Niche was successfully created.' }
        format.json { render :show, status: :created, location: @niche }
      else
        format.html { render :new }
        format.json { render json: @niche.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @niche.update(niche_params)
        format.html { redirect_to @niche, notice: 'Niche was successfully updated.' }
        format.json { render :show, status: :ok, location: @niche }
      else
        format.html { render :edit }
        format.json { render json: @niche.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @niche.destroy
    respond_to do |format|
      format.html { redirect_to niches_url, notice: 'Niche was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_nich
      @niche = Niche.find(params[:id])
    end

    def niche_params
      params.require(:niche).permit(:employer_id, :industry_id)
    end
end
