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
end
