class LeasesController < ApplicationController
  before_action :set_lease, only: [:show, :edit, :update, :destroy]

  def index
    @leases = case params[:filtered_attribute]
    when 'referral_source_id'
      ReferralSource.find(params[:filter_value]).leases
    when nil
      Lease.all
    else
      Lease.where params[:filtered_attribute] => params[:filter_value]
    end.page params[:page]
  end

  def show
  end

  def new
    @lease = Lease.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    @lease = Lease.new(lease_params)

    respond_to do |format|
      if @lease.save
        format.html { redirect_to @lease, notice: 'Lease was successfully created.' }
        format.json { render :show, status: :created, location: @lease }
      else
        format.html { render :new }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lease.update(lease_params)
        format.html { redirect_to @lease, notice: 'Lease was successfully updated.' }
        format.json { render :show, status: :ok, location: @lease }
      else
        format.html { render :edit }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lease.destroy
    respond_to do |format|
      format.html { redirect_to leases_url, notice: 'Lease was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_lease
      @lease = Lease.find(params[:id])
    end

    def lease_params
      params.require(:lease).permit(:apartment_number, :street_number, :street_name, :zip_code, :landlord_id, :client_id, :registration_id)
    end
end
