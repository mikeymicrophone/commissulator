class Avatars::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def contactually
    Rails.logger.info request.env['omniauth.auth']
    @avatar = Avatar.from_omniauth request.env["omniauth.auth"]

    if @avatar.persisted?
      sign_in_and_redirect @avatar, event: :authentication
      # set_flash_message(:notice, :success, kind: "Contactually") if is_navigational_format?
    else
      session["devise.contactually_data"] = request.env["omniauth.auth"]
      redirect_to new_avatar_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
