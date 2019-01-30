class Employment < ApplicationRecord
  include Sluggable

  belongs_to :client
  belongs_to :employer
  validates_associated :employer

  def to_param
    basic_slug client.first_name, client.last_name
  end
  
  def phones
    Phone.where :client => client, :employer => employer
  end
  
  def emails
    Email.where :client => client, :employer => employer
  end
  
  def social_accounts
    SocialAccount.where :client => client, :employer => employer
  end
  
  def contacts
    phones + emails + social_accounts
  end
  
  def name
    info = client.name
    info += " as #{position}" if position.present?
    info += " at #{employer.name}"
    info += " making #{ApplicationController.helpers.number_to_round_currency income}" if income.present?
    info += " since #{start_date.to_s}" if start_date.present?
    info
  end
  
  def fub_description
    description = "#{client.name} is "
    description += "employed at #{employer.name} " unless employer == Employer.unspecified
    description += "as a #{position} " if position.present?
    description += "making #{number_to_round_currency income} annually " if income.present?
    description += "since #{start_date.strftime "%B %Y"}" if start_date.present?
    description.chomp + '.'
  end
  
  def annotate_fub
    employee_note = FubClient::Note.new
    employee_note.subject = "Employment parameters"
    employee_note.body = fub_description
    employee_note.personId = client.follow_up_boss_id
    employee_note.isHtml = true
    begin
      employee_note.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
    employer_note = FubClient::Note.new
    employer_note.subject = "Employment parameters"
    employer_note.body = fub_description
    employer_note.personId = employer.follow_up_boss_id
    employer_note.isHtml = true
    begin
      employer_note.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
  end
end
