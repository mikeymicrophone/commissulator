prawn_document do |pdf|
  pdf.image "#{Rails.root}/app/assets/images/chLogox1.jpg", :width => 120
  pdf.draw_text "Rental Request for Commission", :style => :bold, :size => 15, :at => [150, 720]
  pdf.move_down 50
  pdf.default_leading 7
  pdf.font "Helvetica", :style => :bold, :size => 8
  pdf.text "Branch Name   <u>#{@commission.branch_name}</u>   Request Date   <u>#{@commission.request_date.strftime("%-m/%-d/%Y")}</u>   Intranet Deal Number", :inline_format => true
  pdf.text "Agent Name   <u>#{@commission.agent_name}</u>     Agent Split %    <u>#{@commission.agent_split_percentage}</u>   Copy of Lease   <u>#{@commission.copy_of_lease}</u>", :inline_format => true
  pdf.text "Property Address   <u>#{@commission.property_address}</u>   Apt #   <u>#{@commission.apartment_number}</u>   Zip Code   <u>#{@commission.zip_code}</u>", :inline_format => true
  pdf.text "Bedrooms   <u>#{@commission.bedrooms}</u>   SQ Footage   <u>#{@commission.square_footage}</u>   Property Type   <u>#{@commission.property_type}</u>   New Development   <u>#{@commission.new_development}</u>", :inline_format => true
  
  pdf.draw_text "Tenant Name(s)", :at => [0, 615]
  pdf.draw_text "Tenant Email(s)", :at => [170, 615]
  pdf.draw_text "Tenant Phone #(s)", :at => [355, 615]
  y_position = 615
  @commission.tenant_name.each_with_index do |name, index|
    y_position = 615 - 15 * index
    # pdf.move_down 15
    pdf.draw_text @commission.tenant_name[index], :at => [70, y_position]
    pdf.draw_text @commission.tenant_email[index], :at => [235, y_position]
    pdf.draw_text @commission.tenant_phone_number[index], :at => [428, y_position]
  end
  y_position -= 20
  
  # pdf.move_down 5
  pdf.draw_text "Landlord Name", :at => [0, y_position]
  pdf.draw_text "Landlord Email", :at => [170, y_position]
  pdf.draw_text "Landlord Phone #", :at => [355, y_position]
  pdf.draw_text @commission.landlord_name, :at => [70, y_position]
  pdf.draw_text @commission.landlord_email, :at => [235, y_position]
  pdf.draw_text @commission.landlord_phone_number, :at => [428, y_position]
  
end
