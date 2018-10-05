class RegistrationsController < ApplicationController
  skip_before_action :authenticate_avatar!, :only => :update
  before_action :set_registration, only: [:show, :display, :card, :edit, :update, :destroy]

  def index
    @registrations = case params[:filtered_attribute]
      
    when nil
      Registration.all
    else
      Registration.where params[:filtered_attribute] => params[:filter_value]
    end
    @registrations = case params[:sort]
    when nil
      @registrations.recent
    else
      @registrations.order params[:sort]
    end.page params[:page]
  end

  def show
  end
  
  def display
    @registrant = @registration.registrants.first
    @first_client = @registrant.client
    @title = "#{@first_client.name} Registration Card"
  end
  
  def card
    reg_card_template = File.readlines(Rails.root.join('app', 'views', 'registrations', 'card.pdf.prawn'))[1..-2].join
    pdf_builder = PrawnRails::Document.new(:page_size => 'A4', :page_layout => :portrait)
    registration_id = params[:id]
    view_context_holder = view_context
    pdf_builder.instance_eval do
      @registration = Registration.find registration_id
      @registration_introduction = view_context_holder.t('hello')[:registration_card]
      @registration_implication = view_context_holder.t('legal')[:registration_card][:implication]
      @registration_rental_fee = view_context_holder.t('legal')[:registration_card][:rental_fee]
      @registration_condo_fee = view_context_holder.t('legal')[:registration_card][:condo_fee]
      @registration_short_term = view_context_holder.t('legal')[:registration_card][:short_term]
      @registration_short_term_fees = view_context_holder.t('legal')[:registration_card][:short_term_fees]
      @view_context_holder = view_context_holder
      eval reg_card_template
    end

    front_page_filename = Rails.root.join('tmp', "registration_#{params[:id]}.pdf")
    back_page_filename = Rails.root.join('app', 'assets', 'pdfs', 'registration_card-back_page.pdf')
    disclosure_filename = Rails.root.join('app', 'assets', 'pdfs', 'LandlordTenant_Disclosure.pdf')
    File.open(front_page_filename, 'wb') do |f|
      f.write pdf_builder.render
    end

    full_reg_card = CombinePDF.load(front_page_filename) << CombinePDF.load(back_page_filename) << CombinePDF.load(disclosure_filename)

    full_reg_card_filename = Rails.root.join('tmp', "joined_registration_#{params[:id]}.pdf")
    full_reg_card.save full_reg_card_filename

    send_file full_reg_card_filename, :disposition => :inline, :type => 'application/pdf', :filename => "Registration #{params[:id]}.pdf"
  end

  def new
    @registration = Registration.new
    render :layout => 'empty'
  end

  def edit
  end

  def create
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render :show, status: :created, location: @registration }
      else
        format.html { render :new }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.js
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration }
      else
        format.html { render :edit }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url, notice: 'Registration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def fabricate
    @registration = Fabricate :complete_registration
    @registration.follow_up!
    @registration.fully_annotate_fub!
    redirect_to @registration
  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:minimum_price, :maximum_price, :size, :move_by, :reason_for_moving, :occupants, :pets, :referral_source_id, :agent_id, :signature)
    end
end
