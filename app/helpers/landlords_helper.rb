module LandlordsHelper
  def landlord_row_for landlord
    columns = [
      content_tag(:td, landlord.name),
      content_tag(:td, link_to_associated(landlord, :commissions)),
      content_tag(:td, link_to_associated(landlord, :leases)),
      content_tag(:td, landlord.email),
      content_tag(:td, landlord.phone_number),
      content_tag(:td, landlord.recent_commission&.approval_date&.to_s(:descriptive)),
      content_tag(:td, landlord.updated_at.to_s(:descriptive)),
      content_tag(:td, link_to('Show', landlord)),
      content_tag(:td, link_to(fa_icon(:highlighter), edit_landlord_path(landlord), :title => 'Edit'))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def fabricate_landlord_link
    link_to 'Fabricate landlord', fabricate_landlords_path, :method => :post, :remote => true unless Rails.env.production?
  end
end
