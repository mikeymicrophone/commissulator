prawn_document do |pdf|
  pdf.image "#{Rails.root}/app/assets/images/chLogox1.jpg", :width => 120
  pdf.draw_text "Rental Request for Commission", :style => :bold, :size => 15, :at => [150, 720]
  pdf.move_down 50
  pdf.default_leading 7
  pdf.font "Helvetica", :style => :bold, :size => 8
  pdf.text "Branch Name   <u>#{@commission.branch_name}</u>   Request Date   <u>#{@commission.request_date.to_formatted_s :american}</u>   Intranet Deal Number", :inline_format => true
  pdf.text "Agent Name   <u>#{@commission.agent_name}</u>     Agent Split %    <u>#{@commission.agent_split_percentage}</u>   Copy of Lease   <u>#{@commission.copy_of_lease}</u>", :inline_format => true
  pdf.text "Property Address   <u>#{@commission.property_address}</u>   Apt #   <u>#{@commission.apartment_number}</u>   Zip Code   <u>#{@commission.zip_code}</u>", :inline_format => true
  pdf.text "Bedrooms   <u>#{@commission.bedrooms}</u>   SQ Footage   <u>#{@commission.square_footage}</u>   Property Type   <u>#{@commission.property_type}</u>   New Development   <u>#{@commission.new_development}</u>", :inline_format => true
  
  pdf.draw_text "Tenant Name(s)", :at => [0, 615]
  pdf.draw_text "Tenant Email(s)", :at => [170, 615]
  pdf.draw_text "Tenant Phone #(s)", :at => [355, 615]
  y_position = 615
  @commission.tenant_name.each_with_index do |name, index|
    y_position = 615 - 15 * index
    pdf.move_down 15
    pdf.draw_text @commission.tenant_name[index], :at => [70, y_position]
    pdf.draw_text @commission.tenant_email[index], :at => [235, y_position]
    pdf.draw_text @commission.tenant_phone_number[index], :at => [428, y_position]
  end
  
  y_position -= 20
  pdf.move_down 20
  pdf.draw_text "Landlord Name", :at => [0, y_position]
  pdf.draw_text "Landlord Email", :at => [170, y_position]
  pdf.draw_text "Landlord Phone #", :at => [355, y_position]
  pdf.draw_text @commission.landlord_name, :at => [70, y_position]
  pdf.draw_text @commission.landlord_email, :at => [235, y_position]
  pdf.draw_text @commission.landlord_phone_number, :at => [428, y_position]
  
  pdf.text "Lease Sign Date   <u>#{@commission.lease_sign_date.to_s :american}</u>   Lease Start Date   <u>#{@commission.lease_start_date.to_s :american}</u>   Lease Term Date   <u>#{@commission.lease_term_date.to_s :american}</u>   Approval Date   <u>#{@commission.approval_date.to_s :american}</u>", :inline_format => true
  pdf.text "Listed Monthly Rent   <u>#{number_to_currency @commission.listed_monthly_rent}</u>   Leased Monthly Rent   <u>#{number_to_currency @commission.leased_monthly_rent}</u>   Annualized Rent   <u>#{number_to_currency @commission.annualized_rent}</u>", :inline_format => true
  pdf.text "Commission Fee %   <u>#{@commission.commission_fee_percentage}</u>   Total Commission   <u>#{number_to_currency @commission.total_commission}</u>   Citi Commission   <u>#{number_to_currency @commission.citi_commission}</u>   Co-Broke Commission   <u>#{number_to_currency @commission.co_broke_commission}</u>", :inline_format => true
  pdf.text "OP Commission   <u>#{number_to_currency @commission.owner_pay_commission}</u>   Listing Side Commission   <u>#{number_to_currency @commission.listing_side_commission}</u>   Tenant Side Commission   <u>#{number_to_currency @commission.tenant_side_commission}</u>", :inline_format => true
  
  pdf.text "Reason for fee reduction:", :size => 12
  
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 40 do
    pdf.stroke_bounds
  end
  
  pdf.move_down 20
  pdf.text "Landlord Source:   <u>                              </u>     Tenant Source:   <u>                              </u>_", :inline_format => true, :size => 12
  
  pdf.text "[checkboxes go here]"
  
  pdf.text "Flat Fees/Special Payments/Comments:", :size => 12
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 40 do
    pdf.move_down 10
    pdf.text @commission.subcommission_payout_summary, :indent_paragraphs => 5
    pdf.stroke_bounds
  end
  
  pdf.move_down 15
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 90 do
    pdf.move_down 1
    pdf.text 'Approvals', :size => 7
    
    pdf.draw_text "Requested by: ______________________         _________________________      Date: _____________", :at => [20, 60], :size => 10
    pdf.draw_text "Approved by:  ______________________         _________________________      Date: _____________", :at => [20, 20], :size => 10
    
    pdf.draw_text "Print Agent Name", :at => [120, 50], :size => 7, :style => :bold_italic
    pdf.draw_text "Print Branch Manager Name", :at => [100, 10], :size => 7, :style => :bold_italic
    pdf.draw_text "Agent Signature", :at => [280, 50], :size => 7, :style => :italic
    pdf.draw_text "Branch Manager Signature", :at => [260, 10], :size => 7, :style => :italic
    
    pdf.stroke_bounds
  end
end
