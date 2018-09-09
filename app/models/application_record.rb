class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  scope :recent, lambda { order 'updated_at desc'}
  
  def foreign_key_name
    self.class.name.underscore + '_id'
  end
  
  def icon
    case self
    when Client
      :address_book
    when Registrant
      :address_card
    when Registration
      :archive
    when Industry
      :book_open
    when Niche
      :book_reader
    when Employer
      :bullhorn
    when Employment
      :briefcase
    when Phone
      :bell
    when Email
      :closed_captioning
    when SocialAccount
      :asterisk
    when Landlord
      :warehouse
    when ReferralSource
      :brain
    when Lease
      :building
    when Apartment
      :bed #:archway
    when Deal
      :balance_scale
    when Assistant
      :users
    when Avatar
      :user_tie
    when Document
      :clipboard_list
    when Assist
      :basketball_ball
    when Commission
      :chart_pie
    end
  end
  
  def anchor attribute = :name
    attribute ||= :name
    "#{ApplicationController.helpers.fa_icon icon} #{send attribute}".html_safe
  end
end
