class HomeController < ApplicationController
  skip_before_action :authenticate_avatar!

  def landing
  end
  
  def registration
    
  end
  
  def submit
    @registration = Registration.create registration_params
    
    params[:client][:date_of_birth] = Date.strptime client_params[:date_of_birth], '%m/%d/%Y' rescue nil
    @client = Client.create client_params
    @registrant = Registrant.create registrant_params.merge(:registration => @registration, :client => @client)
    @landlord = Landlord.create landlord_params
    @lease = Lease.create lease_params.merge(:landlord => @landlord, :client => @client, :registration => @registration)

    @home_phone = Phone.create home_phone_params.merge(:client => @client, :variety => 'home')
    @cell_phone = Phone.create cell_phone_params.merge(:client => @client, :variety => 'cell')
    @email = Email.create email_params.merge(:client => @client, :variety => 'primary')
    
    @employer = Employer.find_or_create_by employer_params
    @industry = Industry.find_or_create_by industry_params
    @niche = Niche.find_or_create_by :employer => @employer, :industry => @industry
    @employment = Employment.create employment_params.merge(:client => @client, :employer => @employer)
    
    @office_phone = Phone.create office_phone_params.merge(:client => @client, :employer => @employer, :variety => 'office')
    @office_fax = Phone.create office_fax_params.merge(:client => @client, :employer => @employer, :variety => 'fax')

    if first_roommate_filled_out?
      params[:roommate_1_client][:date_of_birth] = Date.strptime roommate_client_params[:date_of_birth], '%m/%d/%Y' rescue nil
      @roommate = Client.create roommate_client_params
      Registrant.create roommate_registrant_params.merge(:registration => @registration, :client => @roommate)
      @roommate_employer = Employer.find_or_create_by(roommate_employer_params)
      @roommate_employment = Employment.create roommate_employment_params.merge(:client => @roommate, :employer => @roommate_employer)
      @roommate_cell_phone = Phone.create roommate_cell_phone_params.merge(:client => @roommate, :variety => 'cell')
    end
    if second_roommate_filled_out?
      params[:roommate_2_client][:date_of_birth] = Date.strptime second_roommate_client_params[:date_of_birth], '%m/%d/%Y' rescue nil
      @second_roommate = Client.create second_roommate_client_params
      Registrant.create second_roommate_registrant_params.merge(:registration => @registration, :client => @second_roommate)
      @second_roommate_employer = Employer.find_or_create_by(second_roommate_employer_params)
      @second_roommate_employment = Employment.create second_roommate_employment_params.merge(:client => @second_roommate, :employer => @second_roommate_employer)
      @second_roommate_cell_phone = Phone.create second_roommate_cell_phone_params.merge(:client => @second_roommate, :variety => 'cell')
    end
    if third_roommate_filled_out?
      params[:roommate_3_client][:date_of_birth] = Date.strptime third_roommate_client_params[:date_of_birth], '%m/%d/%Y' rescue nil
      @third_roommate = Client.create third_roommate_client_params
      Registrant.create third_roommate_registrant_params.merge(:registration => @registration, :client => @third_roommate)
      @third_roommate_employer = Employer.find_or_create_by(third_roommate_employer_params)
      @third_roommate_employment = Employment.create third_roommate_employment_params.merge(:client => @third_roommate, :employer => @third_roommate_employer)
      @third_roommate_cell_phone = Phone.create third_roommate_cell_phone_params.merge(:client => @third_roommate, :variety => 'cell')
    end
    
    if first_apartment_filled_out?
      @apartment = Apartment.create apartment_params.merge(:registration => @registration)
    end
    if second_apartment_filled_out?
      @second_apartment = Apartment.create second_apartment_params.merge(:registration => @registration)
    end
  end
  
  private
  def first_roommate_filled_out?
    params[:roommate_1_client][:first_name].present?
  end
  
  def second_roommate_filled_out?
    params[:roommate_2_client][:first_name].present?
  end
  
  def third_roommate_filled_out?
    params[:roommate_3_client][:first_name].present?
  end
  
  def first_apartment_filled_out?
    params[:apartment_1][:street_name].present?
  end
  
  def second_apartment_filled_out?
    params[:apartment_2][:street_name].present?
  end
  
  def registration_params
    params.require(:registration).permit :minimum_price, :maximum_price, :size, :move_by, :reason_for_moving, :occupants, :pets, :referral_source_id, :agent_id
  end
  
  def client_params
    params.require(:client).permit :first_name, :last_name, :date_of_birth
  end
  
  def registrant_params
    params.require(:registrant).permit :other_funding_sources
  end
  
  def landlord_params
    params.require(:landlord).permit :name
  end
  
  def lease_params
    params.require(:lease).permit :apartment_number, :street_number, :street_name, :zip_code
  end
  
  def home_phone_params
    params.require(:home_phone).permit :number
  end

  def cell_phone_params
    params.require(:cell_phone).permit :number
  end
  
  def email_params
    params.require(:email).permit :address
  end
  
  def employer_params
    params.require(:employer).permit :name, :address, :url
  end
  
  def industry_params
    params.require(:industry).permit :name
  end
  
  def employment_params
    params.require(:employment).permit :position, :income, :start_date
  end
  
  def office_phone_params
    params.require(:office_phone).permit :number
  end
  
  def office_fax_params
    params.require(:office_fax).permit :number
  end

  def roommate_client_params
    params.require(:roommate_1_client).permit :first_name, :last_name, :date_of_birth
  end
  
  def roommate_registrant_params
    params.require(:roommate_1_registrant).permit :other_fund_sources
  end
  
  def roommate_employer_params
    params.require(:roommate_1_employer).permit :name, :address
  end
  
  def roommate_employment_params
    params.require(:roommate_1_employment).permit :income, :position, :start_date
  end
  
  def roommate_cell_phone_params
    params.require(:roommate_1_cell_phone).permit :number
  end

  def second_roommate_client_params
    params.require(:roommate_2_client).permit :first_name, :last_name, :date_of_birth
  end
  
  def second_roommate_registrant_params
    params.require(:roommate_2_registrant).permit :other_fund_sources
  end
  
  def second_roommate_employer_params
    params.require(:roommate_2_employer).permit :name, :address
  end
  
  def second_roommate_employment_params
    params.require(:roommate_2_employment).permit :income, :position, :start_date
  end
  
  def second_roommate_cell_phone_params
    params.require(:roommate_2_cell_phone).permit :number
  end

  def third_roommate_client_params
    params.require(:roommate_3_client).permit :first_name, :last_name, :date_of_birth
  end
  
  def third_roommate_registrant_params
    params.require(:roommate_3_registrant).permit :other_fund_sources
  end
  
  def third_roommate_employer_params
    params.require(:roommate_3_employer).permit :name, :address
  end
  
  def third_roommate_employment_params
    params.require(:roommate_3_employment).permit :income, :position, :start_date
  end
  
  def third_roommate_cell_phone_params
    params.require(:roommate_3_cell_phone).permit :number
  end
  
  def apartment_params
    params.require(:apartment_1).permit :unit_number, :street_number, :street_name, :zip_code, :size, :rent, :comment
  end

  def second_apartment_params
    params.require(:apartment_2).permit :unit_number, :street_number, :street_name, :zip_code, :size, :rent, :comment
  end
end
