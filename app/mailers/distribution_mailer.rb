class DistributionMailer < ApplicationMailer
  def submit_to_senior
    @commission = params[:commission]
    @subject = "Deal for review: #{@commission.deal.reference}"
    mail :to => ENV['SENIOR_AGENT_EMAIL'], :subject => @subject
  end
end
