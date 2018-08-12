prawn_document do |pdf|
  pdf.text "Branch Name   #{@commission.branch_name}   Request Date   #{@commission.request_date.strftime("%-m/%-d/%Y")}   Intranet Deal Number"
  pdf.stroke_line [78, 760], [190, 760]
  pdf.stroke_line [270, 760], [338, 760]
  pdf.stroke_line [460, 760], [500, 760]
  pdf.text "Agent Name   #{@commission.agent_name}     Agent Split %    #{@commission.agent_split_percentage}   Copy of Lease   #{@commission.copy_of_lease}"
  pdf.stroke_line [71, 745], [144, 745]
  pdf.stroke_line [238, 745], [266, 745]
  pdf.stroke_line [356, 745], [390, 745]
  pdf.text "Property Address   #{@commission.property_address}   Apt #   #{@commission.apartment_number}   Zip Code   #{@commission.zip_code}"
  pdf.text "Bedrooms   #{@commission.bedrooms}   SQ Footage   #{@commission.square_footage}   Property Type   #{@commission.property_type}   New Development   #{@commission.new_development}"
end
