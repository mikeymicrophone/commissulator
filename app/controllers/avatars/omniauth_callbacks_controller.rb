class Avatars::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def contactually
    Rails.logger.info request.env['omniauth.auth']
    @avatar = Avatar.from_omniauth request.env["omniauth.auth"]

    if @avatar.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Contactually'
      sign_in_and_redirect @avatar, event: :authentication
    else
      session["devise.contactually_data"] = request.env["omniauth.auth"]
      redirect_to new_avatar_registration_url
    end
  end

  def google_oauth2
    auth = request.env['omniauth.auth']
    @avatar = Avatar.from_omniauth auth
    token = auth.credentials.token
    @agent = @avatar.agent
    filename = "google_#{@agent.id}_#{@agent.name}.token"
    File.open Rails.root.join('tmp', filename), 'w+' do |file|
      file.write token
    end
    @agent&.cookies&.attach :io => File.open(Rails.root.join('tmp', filename)), :filename => filename

    if @avatar.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @avatar, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_avatar_registration_url, alert: @avatar.errors.full_messages.join("\n")
    end
  end
  
  def microsoft_office365
    auth = request.env['omniauth.auth']
    @avatar = Avatar.from_omniauth auth
    token = auth.credentials.token
    @agent = @avatar.agent
    filename = "microsoft_#{@agent.id}_#{@agent.name}.token"
    File.open Rails.root.join('tmp', filename), 'w+' do |file|
      file.write token
    end
    @agent&.cookies&.attach :io => File.open(Rails.root.join('tmp', filename)), :filename => filename

    if @avatar.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Microsoft'
      sign_in_and_redirect @avatar, event: :authentication
    else
      session['devise.microsoft_data'] = request.env['omniauth.auth']
      redirect_to new_avatar_registration_url, alert: @avatar.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path
  end
end
