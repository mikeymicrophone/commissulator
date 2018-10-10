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

  def google_oauth2
    @avatar = Avatar.from_omniauth(request.env['omniauth.auth'])

    if @avatar.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @avatar, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_avatar_registration_url, alert: @avatar.errors.full_messages.join("\n")
    end
  end
  
  def microsoft_office365
    @avatar = Avatar.from_omniauth(request.env['omniauth.auth'])

    if @avatar.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Microsoft'
      sign_in_and_redirect @avatar, event: :authentication
    else
      session['devise.microsoft_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_avatar_registration_url, alert: @avatar.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path
  end
end
