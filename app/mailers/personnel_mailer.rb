class PersonnelMailer < ApplicationMailer
  def activation_request
    @avatar = params[:avatar]
    @recipients = Avatar.admin.map(&:email)
    @subject = "Access requested for: #{@avatar.reference}"
    mail :to => @recipients, :subject => @subject
  end
  
  def activation_grant
    @avatar = params[:avatar]
    @recipients = Avatar.admin.map(&:email)
    @subject = "Access granted for: #{@avatar.reference}"
    mail :to => @recipients, :subject => @subject
  end
  
  def activation_revoke
    @avatar = params[:avatar]
    @recipients = Avatar.admin.map(&:email)
    @subject = "Access revoked for: #{@avatar.reference}"
    mail :to => @recipients, :subject => @subject
  end
end
