class AvatarsController < ApplicationController
  before_action :set_avatar
  
  def index
    @avatars = Avatar.all
  end
  
  def show
    @avatar = Avatar.find params[:id] if current_avatar.admin?
  end
  
  def edit
  end
  
  def update
    @avatar.update avatar_params
    redirect_to deals_path
  end
  
  def activate
    @avatar = Avatar.find params[:id] if current_avatar.admin?
    @avatar.activated = true
    @avatar.save
  end
  
  def deactivate
    @avatar = Avatar.find params[:id] if current_avatar.admin?
    @avatar.activated = false
    @avatar.save
  end
  
  private
  def set_avatar
    @avatar = current_avatar
  end
  
  def avatar_params
    params.require(:avatar).permit(:first_name, :last_name, :phone_number)
  end
end
