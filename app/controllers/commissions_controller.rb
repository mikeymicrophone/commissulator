class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :print, :edit, :update, :destroy]

  def index
    @commissions = if params[:landlord_id]
      Commission.where :landlord_id => params[:landlord_id]
    else
      Commission.all
    end.page params[:page]
  end

  def show
    @filename = "Rental Request for Commission.pdf"
  end

  def new
    @deal = Deal.where(:id => params[:deal_id]).take
    if @deal
      @commission = Commission.new :deal => @deal, :property_address => @deal.address, :apartment_number => @deal.unit_number
    else
      @commission = Commission.new :deal => Deal.create(:agent => current_agent)
      @deal = @commission.deal
    end
  end
  
  def add_tenant_to
  end

  def edit
    @deal = @commission.deal
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
    fabricator = params[:fabricator] || :commission
    @commission = Fabricate fabricator.to_sym, :agent => current_agent
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
        :annualized_rent, :total_commission, :citi_commission, :co_broke_commission, :deal_id, :landlord_id, :referral_payment,
        :co_exclusive_agency, :co_exclusive_agency_name, :exclusive_agency, :exclusive_agency_name, :exclusive_agent, :exclusive_agent_name,
        :exclusive_agent_office, :open_listing, :citi_habitats_agent, :citi_habitats_agent_name, :citi_habitats_agent_office,
        :corcoran_agent, :corcoran_agent_name, :corcoran_agent_office, :co_broke_company, :co_broke_company_name, :direct_deal,
        :citi_habitats_referral_agent, :citi_habitats_referral_agent_name, :citi_habitats_referral_agent_office,
        :citi_habitats_referral_agent_amount, :corcoran_referral_agent, :corcoran_referral_agent_name, :corcoran_referral_agent_office,
        :corcoran_referral_agent_amount, :outside_agency, :outside_agency_name, :outside_agency_amount, :relocation_referral,
        :relocation_referral_name, :relocation_referral_amount, :listing_fee, :listing_fee_name, :listing_fee_office, :listing_fee_percentage)
    end
end
