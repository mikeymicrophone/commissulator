class CommissionsController < ApplicationController
  load_and_authorize_resource :except => [:index, :fabricate]
  # before_action :set_commission, only: [:show, :edit, :update, :submit, :follow_up, :destroy]

  def index
    @commissions = if params[:filtered_attribute]
      Commission.where params[:filtered_attribute] => params[:filter_value]
    else
      Commission.visible_to current_avatar
    end
    @commissions = case params[:sort]
    when 'updated_at'
      @commissions.order 'updated_at desc'
    when 'leased_monthly_rent'
      @commissions.order 'leased_monthly_rent desc'
    when 'total_commission'
      @commissions.order 'total_commission desc nulls last'
    when 'property_address'
      @commissions.order 'property_address'
    else
      @commissions.order 'created_at desc'
    end.page params[:page]
  end

  def show
    @sensitive = !current_avatar.admin
    @filename = "Rental Request for Commission.pdf"
  end

  def new
    @deal = Deal.where(:id => params[:deal_id]).take
    if @deal
      @commission = Commission.new :deal => @deal, :property_address => @deal.address, :apartment_number => @deal.unit_number
    else
      @agent = Agent.where(:first_name => ENV['SENIOR_AGENT_FIRST_NAME']).take
      @deal = Deal.create(:agent => @agent, :package => Package.default)
      @commission = Commission.new :deal => @deal, :agent => @agent
    end
  end
  
  def add_tenant_to
  end
  
  def follow_up
    @commission.follow_up!
    # @commission.contactually_up!
    @commission.update_attribute :follow_up, :submitted
  end

  def edit
    @deal = @commission.deal
  end

  def create
    @commission = Commission.new commission_params

    respond_to do |format|
      if @commission.save
        if params[:commit] == 'Save and Print'
          format.html { redirect_to commission_path(@commission, :format => :pdf) }
        else
          format.html { redirect_to @commission, notice: 'Commission was created.' }
          format.json { render :show, status: :created, location: @commission }
        end
      else
        format.html { render :new }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @commission.update commission_params
        if params[:commit] == 'Save and Print'
          format.html { redirect_to commission_path(@commission, :format => :pdf) }
        else
          format.html { redirect_to @commission, notice: 'Commission was updated.' }
          format.json { render :show, status: :ok, location: @commission }
        end
      else
        format.html { render :edit }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def prune
    
  end

  def destroy
    @commission.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to commissions_url, notice: 'Commission was destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def submit
    @commission.update_attribute :submitted_on, Time.now
    DistributionMailer.with(:commission => @commission).submit_to_senior.deliver
  end

  def fabricate
    fabricator = params[:fabricator] || :commission
    @commission = Fabricate fabricator.to_sym, :agent => Agent.where(:first_name => ENV['SENIOR_AGENT_FIRST_NAME']).take
  end

  private
    # def set_commission
    #   @commission = Commission.find params[:id]
    # end

    def commission_params
      params.require(:commission).permit(:agent_id, :branch_name, {:tenant_name => []}, {:tenant_email => []}, {:tenant_phone_number => []}, :landlord_name, :landlord_email, :landlord_phone_number,
        :agent_name, :bedrooms, :property_type, :new_development, :lease_start_date, :lease_term, :square_footage,
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
