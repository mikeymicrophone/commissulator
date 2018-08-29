class LandlordsController < ApplicationController
  before_action :set_landlord, only: [:show, :edit, :update, :destroy]

  def index
    @landlords = case params[:sort]
    when 'recent_commission'
      Landlord.joins(:commissions).order('commissions.approval_date desc nulls last')
    when 'name'
      Landlord.order :name
    when 'deal_count'
      Kaminari.paginate_array Landlord.all.sort_by { |landlord| landlord.commissions.count }.reverse
    else
      Landlord.all
    end.page params[:page]
  end

  def show
  end

  def new
    @landlord = Landlord.new
  end

  def edit
  end

  def create
    @landlord = Landlord.new(landlord_params)

    respond_to do |format|
      if @landlord.save
        format.html { redirect_to @landlord, notice: 'Landlord was successfully created.' }
        format.json { render :show, status: :created, location: @landlord }
      else
        format.html { render :new }
        format.json { render json: @landlord.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @landlord.update(landlord_params)
        format.html { redirect_to @landlord, notice: 'Landlord was successfully updated.' }
        format.json { render :show, status: :ok, location: @landlord }
      else
        format.html { render :edit }
        format.json { render json: @landlord.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @landlord.destroy
    respond_to do |format|
      format.html { redirect_to landlords_url, notice: 'Landlord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def fabricate
    @landlord = Fabricate :landlord
  end

  private
    def set_landlord
      @landlord = Landlord.find(params[:id])
    end

    def landlord_params
      params.require(:landlord).permit(:name, :email, :phone_number)
    end
end
