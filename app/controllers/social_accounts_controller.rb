class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: [:show, :edit, :update, :destroy]

  def index
    @social_accounts = case params[:filtered_attribute]
    when 'industry_id'
      Industry.find(params[:filter_value]).social_accounts
    when nil
      SocialAccount.all
    else
      SocialAccount.where params[:filtered_attribute] => params[:filter_value]
    end.page params[:page]
  end

  def show
  end

  def new
    @social_account = SocialAccount.new
  end

  def edit
  end

  def create
    @social_account = SocialAccount.new(social_account_params)

    respond_to do |format|
      if @social_account.save
        format.html { redirect_to @social_account, notice: 'Social account was successfully created.' }
        format.json { render :show, status: :created, location: @social_account }
      else
        format.html { render :new }
        format.json { render json: @social_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @social_account.update(social_account_params)
        format.html { redirect_to @social_account, notice: 'Social account was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_account }
      else
        format.html { render :edit }
        format.json { render json: @social_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @social_account.destroy
    respond_to do |format|
      format.html { redirect_to social_accounts_url, notice: 'Social account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_social_account
      @social_account = SocialAccount.find(params[:id])
    end

    def social_account_params
      params.require(:social_account).permit(:variety, :url, :moniker, :client_id, :employer_id)
    end
end
