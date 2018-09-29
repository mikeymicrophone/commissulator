class HomeController < ApplicationController
  skip_before_action :authenticate_avatar!

  def landing
  end
  
  def registration
    render :layout => 'empty'
  end
  
  def registrant_add
    @roommates_to_add = params[:number_of_roommates].to_i - 2
  end
  
  def submit
    params[:registration][:move_by] = Date.strptime registration_params[:move_by], '%m/%d/%Y' rescue nil
    @registration = Registration.create registration_params

    5.times do |roommate_number|
      if roommate_filled_out?(roommate_number)
        params["client_#{roommate_number}"][:date_of_birth] = Date.strptime client_params(roommate_number)[:date_of_birth], '%m/%d/%Y' rescue nil
        @client = Client.create client_params(roommate_number)
        @registrant = Registrant.create registrant_params(roommate_number).merge(:registration => @registration, :client => @client)
        @landlord = Landlord.create landlord_params(roommate_number) if landlord_params(roommate_number)[:name].present?
        @lease = Lease.create lease_params(roommate_number).merge(:landlord => @landlord, :registration => @registration)
        @tenant = Tenant.create :lease => @lease, :client => @client

        @home_phone = Phone.create home_phone_params(roommate_number).merge(:client => @client, :variety => 'home')
        @cell_phone = Phone.create cell_phone_params(roommate_number).merge(:client => @client, :variety => 'cell')
        @email = Email.create email_params(roommate_number).merge(:client => @client, :variety => 'primary')

        @employer = Employer.find_or_create_by employer_params(roommate_number)
        @employer = Employer.unspecified unless @employer.valid?
        @industry = Industry.find_or_create_by industry_params(roommate_number)
        @niche = Niche.find_or_create_by :employer => @employer, :industry => @industry
        @employment = Employment.create employment_params(roommate_number).merge(:client => @client, :employer => @employer)
    
        @office_phone = Phone.create office_phone_params(roommate_number).merge(:client => @client, :employer => @employer, :variety => 'office')
        @office_hiring = Phone.create office_hiring_params(roommate_number).merge(:employer => @employer, :variety => 'hiring')
      end
    end
    
    if first_apartment_filled_out?
      @apartment = Apartment.create apartment_params.merge(:registration => @registration)
    end
    if second_apartment_filled_out?
      @second_apartment = Apartment.create second_apartment_params.merge(:registration => @registration)
    end
    
    @registration.reload.follow_up!
    redirect_to :action => :thanks, :registration_id => @registration.id
  end
  
  def thanks
    @registration = Registration.find params[:registration_id]
    render :layout => 'empty'
  end
  
  def toggle_navigation
  end
  
  private
  def roommate_filled_out? number
    params["client_#{number}"] && params["client_#{number}"][:first_name].present?
  end
  
  def first_apartment_filled_out?
    params[:apartment_1][:street_name].present?
  end
  
  def second_apartment_filled_out?
    params[:apartment_2][:street_name].present?
  end
  
  def registration_params
    params.require("registration").permit :minimum_price, :maximum_price, :size, :move_by, :move_by_latest, :reason_for_moving, :what_if_we_fail, :occupants, :pets, :referral_source_id, :agent_id
  end
  
  def client_params roommate_number
    params.require("client_#{roommate_number}").permit :first_name, :last_name, :date_of_birth
  end
  
  def registrant_params roommate_number
    params.require("registrant_#{roommate_number}").permit :other_funding_sources
  end
  
  def landlord_params roommate_number
    params.require("landlord_#{roommate_number}").permit :name
  end
  
  def lease_params roommate_number
    params.require("lease_#{roommate_number}").permit :apartment_number, :street_number, :street_name, :zip_code
  end
  
  def home_phone_params roommate_number
    params.require("home_phone_#{roommate_number}").permit :number
  end

  def cell_phone_params roommate_number
    params.require("cell_phone_#{roommate_number}").permit :number
  end
  
  def email_params roommate_number
    params.require("email_#{roommate_number}").permit :address
  end
  
  def employer_params roommate_number
    params.require("employer_#{roommate_number}").permit :name, :address, :url
  end
  
  def industry_params roommate_number
    params.require("industry_#{roommate_number}").permit :name
  end
  
  def employment_params roommate_number
    params.require("employment_#{roommate_number}").permit :position, :income, :start_date
  end
  
  def office_phone_params roommate_number
    params.require("office_phone_#{roommate_number}").permit :number
  end
  
  def office_hiring_params roommate_number
    params.require("office_hiring_#{roommate_number}").permit :number
  end
  
  def apartment_params
    params.require("apartment_1").permit :unit_number, :street_number, :street_name, :zip_code, :size, :rent, :comment
  end

  def second_apartment_params
    params.require("apartment_2").permit :unit_number, :street_number, :street_name, :zip_code, :size, :rent, :comment
  end
end
