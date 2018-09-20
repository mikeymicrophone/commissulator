class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_avatar!
  alias :current_user :current_avatar

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message.concat(" #{exception.action} of #{exception.subject.class.name.downcase} #{exception.subject.id rescue nil}")
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number])
    end
  
    def after_sign_in_path_for resource
      commissions_path
    end
end
