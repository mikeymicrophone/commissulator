class CommissionsController < ApplicationController
  layout 'commissions'
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  def index
    @commissions = Commission.page params[:page]
  end

  def show
  end

  def new
    @commission = Commission.new
  end
  
  def add_tenant_to
  end

  def edit
  end

  def create
    @commission = Commission.new commission_params

    respond_to do |format|
      if @commission.save
        format.html { redirect_to @commission, notice: 'Commission was created.' }
        format.json { render :show, status: :created, location: @commission }
      else
        format.html { render :new }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @commission.update commission_params
        format.html { redirect_to @commission, notice: 'Commission was updated.' }
        format.json { render :show, status: :ok, location: @commission }
      else
        format.html { render :edit }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commission.destroy
    respond_to do |format|
      format.html { redirect_to commissions_url, notice: 'Commission was destroyed.' }
      format.json { head :no_content }
    end
  end

  def fabricate
    @commission = Fabricate :commission, :agent => current_agent
  end

  private
    def set_commission
      @commission = Commission.find params[:id]
    end

    def commission_params
      params.require(:commission).permit(:branch_name, {:tenant_name => []}, {:tenant_email => []}, {:tenant_phone_number => []}, :landlord_name, :landlord_email, :landlord_phone_number,
        :agent_name, :bedrooms, :property_type, :new_development, :lease_start_date, :lease_term_date, :square_footage,
        :listed_monthly_rent, :landlord_source, :tenant_source, :intranet_deal_number, :copy_of_lease, :property_address, :apartment_number,
        :zip_code, :lease_sign_date, :approval_date, :leased_monthly_rent, :commission_fee_percentage, :agent_split_percentage,
        :owner_pay_commission, :listing_side_commission, :tenant_side_commission, :reason_for_fee_reduction, :request_date,
        :annualized_rent, :total_commission, :citi_commission, :co_broke_commission)
    end
end
