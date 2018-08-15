prawn_document do |pdf|
  pdf.image "#{Rails.root}/app/assets/images/chLogox1.jpg", :width => 120
  pdf.draw_text "Rental Request for Commission", :style => :bold, :size => 15, :at => [150, 720]
  pdf.move_down 50
  pdf.default_leading 7
  pdf.font "Helvetica", :style => :bold, :size => 8
  pdf.text "Branch Name   <u>#{pad @commission.branch_name}</u>   Request Date   <u>#{pad @commission.request_date.to_formatted_s(:american), 22}</u>   Intranet Deal Number <u>#{pad ''}</u>", :inline_format => true
  pdf.text "Agent Name   <u>#{pad @commission.agent_name, 30}</u>     Agent Split %    <u>#{pad @commission.agent_split_percentage, 7}</u>   Copy of Lease   <u>#{pad @commission.boolean_display :copy_of_lease}</u>", :inline_format => true
  pdf.text "Property Address   <u>#{pad @commission.property_address, 36}</u>   Apt #   <u>#{pad @commission.apartment_number, 7}</u>   Zip Code   <u>#{pad @commission.zip_code, 8}</u>", :inline_format => true
  pdf.text "Bedrooms   <u>#{pad @commission.bedrooms, 8}</u>   SQ Footage   <u>#{pad @commission.square_footage}</u>   Property Type   <u>#{pad @commission.property_type}</u>   New Development   <u>#{pad @commission.new_development, 3}</u>", :inline_format => true
  
  pdf.draw_text "Tenant Name(s)", :at => [0, 615]
  pdf.draw_text "Tenant Email(s)", :at => [170, 615]
  pdf.draw_text "Tenant Phone #(s)", :at => [355, 615]
  y_position = 615
  @commission.tenant_name.each_with_index do |name, index|
    y_position = 615 - 15 * index
    pdf.move_down 15
    pdf.draw_text @commission.tenant_name[index], :at => [70, y_position]
    pdf.draw_text @commission.tenant_email[index], :at => [235, y_position], :size => 7
    pdf.draw_text @commission.tenant_phone_number[index], :at => [428, y_position]
  end
  
  y_position -= 20
  pdf.move_down 20
  pdf.draw_text "Landlord Name", :at => [0, y_position]
  pdf.draw_text "Landlord Email", :at => [170, y_position]
  pdf.draw_text "Landlord Phone #", :at => [355, y_position]
  pdf.draw_text @commission.landlord_name, :at => [70, y_position]
  pdf.draw_text @commission.landlord_email, :at => [235, y_position], :size => 7
  pdf.draw_text @commission.landlord_phone_number, :at => [428, y_position]
  
  pdf.text "Lease Sign Date   <u>#{pad @commission.lease_sign_date.to_s(:american), 8}</u>   Lease Start Date   <u>#{pad @commission.lease_start_date.to_s(:american), 8}</u>   Lease Term Date   <u>#{pad @commission.lease_term_date.to_s(:american), 8}</u>   Approval Date   <u>#{pad @commission.approval_date.to_s(:american), 8}</u>", :inline_format => true
  pdf.text "Listed Monthly Rent   <u>#{pad number_to_currency @commission.listed_monthly_rent}</u>   Leased Monthly Rent   <u>#{pad number_to_currency @commission.leased_monthly_rent}</u>   Annualized Rent   <u>#{pad number_to_currency @commission.annualized_rent}</u>", :inline_format => true
  pdf.text "Commission Fee %   <u>#{pad @commission.commission_fee_percentage, 4}</u>   Total Commission   <u>#{pad number_to_currency(@commission.total_commission), 8}</u>   Citi Commission   <u>#{pad number_to_currency(@commission.citi_commission), 8}</u>   Co-Broke Commission   <u>#{pad number_to_currency(@commission.co_broke_commission), 8}</u>", :inline_format => true
  pdf.text "OP Commission   <u>#{pad number_to_currency(@commission.owner_pay_commission), 8}</u>   Listing Side Commission   <u>#{pad number_to_currency(@commission.listing_side_commission), 14}</u>   Tenant Side Commission   <u>#{pad number_to_currency(@commission.tenant_side_commission), 14}</u>", :inline_format => true
  
  pdf.text "Reason for fee reduction:", :size => 12
  
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 40 do
    pdf.stroke_bounds
  end
  
  pdf.move_down 20
  pdf.text "Landlord Source:   <u>                              </u>     Tenant Source:   <u>                              </u>_", :inline_format => true, :size => 12
  
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 100 do
    column_positions = [0, 15, 100, 200, 210, 230, 300, 390, 400, 425, 500]
    row_positions = [90, 70, 50, 30, 10]
    
    pdf.rectangle [0, row_positions[0] + 10], 10, 10
    pdf.draw_text "Co-exclusive Agency", :at => [column_positions[1], row_positions[0]]
    pdf.rectangle [0, row_positions[1] + 10], 10, 10
    pdf.draw_text "Exclusive Agency", :at => [column_positions[1], row_positions[1]]
    pdf.rectangle [0, row_positions[2] + 10], 10, 10
    pdf.draw_text "Exclusive Agent", :at => [column_positions[1], row_positions[2]]
    pdf.draw_text "Office", :at => [column_positions[1], row_positions[3]]
    pdf.rectangle [0, row_positions[4] + 10], 10, 10
    pdf.draw_text "Open Listing", :at => [column_positions[1], row_positions[4]]
    
    pdf.stroke_line [column_positions[2], row_positions[0]], [column_positions[3], row_positions[0]]
    pdf.stroke_line [column_positions[2], row_positions[1]], [column_positions[3], row_positions[1]]
    pdf.stroke_line [column_positions[2], row_positions[2]], [column_positions[3], row_positions[2]]
    pdf.stroke_line [column_positions[2], row_positions[3]], [column_positions[3], row_positions[3]]
    
    pdf.rectangle [column_positions[4], row_positions[0] + 10], 10, 10
    pdf.rectangle [column_positions[4], row_positions[1] + 10], 10, 10
    pdf.rectangle [column_positions[4], row_positions[2] + 10], 10, 10
    pdf.rectangle [column_positions[4], row_positions[3] + 10], 10, 10
    
    pdf.draw_text "Citi Habitats Agent", :at => [column_positions[5], row_positions[0]]
    pdf.draw_text "Corcoran Agent", :at => [column_positions[5], row_positions[1]]
    pdf.draw_text "Co-Broke Co.", :at => [column_positions[5], row_positions[2]]
    pdf.draw_text "Direct Deal", :at => [column_positions[5], row_positions[3]]
    
    pdf.stroke_line [column_positions[6], row_positions[0]], [column_positions[7], row_positions[0]]
    pdf.stroke_line [column_positions[6], row_positions[1]], [column_positions[7], row_positions[1]]
    pdf.stroke_line [column_positions[6], row_positions[2]], [column_positions[7], row_positions[2]]
    
    pdf.draw_text "Office", :at => [column_positions[8], row_positions[0]]
    pdf.draw_text "Office", :at => [column_positions[8], row_positions[1]]
    
    pdf.stroke_line [column_positions[9], row_positions[0]], [column_positions[10], row_positions[0]]
    pdf.stroke_line [column_positions[9], row_positions[1]], [column_positions[10], row_positions[1]]
  end
  
  pdf.text "Referral Payment:   <u>                              </u>_", :inline_format => true, :size => 12
  
  pdf.bounding_box [0, pdf.cursor], :width => 510, :height => 100 do
    column_positions = [0, 15, 100, 240, 255, 290, 370, 380, 450, 500]
    row_positions = [90, 70, 50, 30, 10]
    
    pdf.rectangle [0, row_positions[0] + 10], 10, 10
    pdf.draw_text "Citi Habitats Agent", :at => [column_positions[1], row_positions[0]]
    pdf.rectangle [0, row_positions[1] + 10], 10, 10
    pdf.draw_text "Corcoran Agent", :at => [column_positions[1], row_positions[1]]
    pdf.rectangle [0, row_positions[2] + 10], 10, 10
    pdf.draw_text "Outside Agency", :at => [column_positions[1], row_positions[2]]
    pdf.rectangle [0, row_positions[3] + 10], 10, 10
    pdf.draw_text "Relo Referral", :at => [column_positions[1], row_positions[3]]
    pdf.rectangle [0, row_positions[4] + 10], 10, 10
    pdf.draw_text "Listing Fee", :at => [column_positions[1], row_positions[4]]
    pdf.stroke
    
    pdf.stroke_line [column_positions[2], row_positions[0]], [column_positions[3], row_positions[0]]
    pdf.stroke_line [column_positions[2], row_positions[1]], [column_positions[3], row_positions[1]]
    pdf.stroke_line [column_positions[2], row_positions[2]], [column_positions[3], row_positions[2]]
    pdf.stroke_line [column_positions[2], row_positions[3]], [column_positions[3], row_positions[3]]
    pdf.stroke_line [column_positions[2], row_positions[4]], [column_positions[3], row_positions[4]]
    
    pdf.draw_text "Office", :at => [column_positions[4], row_positions[0]]
    pdf.draw_text "Office", :at => [column_positions[4], row_positions[1]]
    pdf.draw_text "Office", :at => [column_positions[4], row_positions[4]]
    
    pdf.stroke_line [column_positions[5], row_positions[0]], [column_positions[6], row_positions[0]]
    pdf.stroke_line [column_positions[5], row_positions[1]], [column_positions[6], row_positions[1]]
    pdf.stroke_line [column_positions[5], row_positions[4]], [column_positions[6], row_positions[4]]
    
    pdf.draw_text "Referral Amount", :at => [column_positions[7], row_positions[0]]
    pdf.draw_text "Referral Amount", :at => [column_positions[7], row_positions[1]]
    pdf.draw_text "Referral Amount", :at => [column_positions[7], row_positions[2]]
    pdf.draw_text "Referral Amount", :at => [column_positions[7], row_positions[3]]
    pdf.draw_text "Listing Fee %", :at => [column_positions[7], row_positions[4]]
    
    pdf.stroke_line [column_positions[8], row_positions[0]], [column_positions[9], row_positions[0]]
    pdf.stroke_line [column_positions[8], row_positions[1]], [column_positions[9], row_positions[1]]
    pdf.stroke_line [column_positions[8], row_positions[2]], [column_positions[9], row_positions[2]]
    pdf.stroke_line [column_positions[8], row_positions[3]], [column_positions[9], row_positions[3]]
    pdf.stroke_line [column_positions[8], row_positions[4]], [column_positions[9], row_positions[4]]
  end
  
  
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
