prawn_document do |pdf|
  # pdf.stroke_axis
  pdf.font_families.update 'Oswald' => {:normal => "#{Rails.root}/app/assets/fonts/Oswald-Medium.ttf"}
  pdf.font "Times-Roman", :size => 10
  pdf.image "#{Rails.root}/app/assets/images/chLogox1.jpg", :width => 240
  pdf.font 'Oswald' do
    pdf.draw_text "CLIENT REGISTRATION / FEE AGREEMENT", :size => 15, :at => [250, 755]
  end
  
  pdf.bounding_box [250, 750], :width => 250 do
    pdf.text "Date: #{@registration.created_at.strftime("%-m/%-d/%Y")}"
    pdf.text "Budget: #{number_to_round_currency @registration.minimum_price}-#{number_to_round_currency @registration.maximum_price}"
    pdf.text "Apartment Size: #{@registration.size}"
    pdf.draw_text "Agent: #{@registration.agent&.name}", :at => [120, 25]
  end
  
  pdf.move_down 10
  pdf.text "Welcome to Citi Habitats.  Thank you for providing us with the opportunity to find your new home.  We look forward to working with you.  Completing the informatino below will ensure that your apartment search goes as smoothly as possible."
  pdf.default_leading 7
  
  
  gap = 5
  
  @registration.clients.each_with_index do |client, index|
    height = 679 - (((index) / 2)) * 260
    positioning = index.odd? ? [255, height] : [0, height]
    pdf.bounding_box positioning, :width => 250 do
      pdf.bounding_box [gap, pdf.cursor - gap], :width => 240 do
        pdf.font 'Oswald' do
          pdf.text "CLIENT #{index + 1}"
        end
        pdf.text client.name
        pdf.text client.leases.first&.address
        client.phones.each do |phone|
          pdf.text "#{phone.number} (#{phone.variety})"
        end
        client.emails.each do |email|
          pdf.text email.address
        end
        client.employers.each do |employer|
          pdf.text "Employer: #{employer.name}"
          pdf.text "Address: #{employer.address}"
          pdf.text "Position: #{employer.employment_of(client)&.position}"
          pdf.text "Annual Income: #{number_to_round_currency employer.employment_of(client)&.income}"
        end
        client.leases.each do |lease|
          pdf.text "Current Landlord: #{lease.landlord&.name}"
        end
      end
      
      pdf.dash 1
      pdf.stroke_bounds
    end
  end
  
  pdf.bounding_box [0, pdf.cursor], :width => 510 do
    pdf.bounding_box [gap, pdf.cursor - gap], :width => 500 do
      pdf.text "Move-in date: #{@registration.move_by&.strftime("%-m/%-d")}    Lease expiration date: #{@registration.move_by_latest&.strftime("%-m/%-d")}    Number of people: #{@registration.occupants}"
      @registration.apartments.each do |apartment|
        pdf.text apartment.name
      end
      pdf.text "How did you hear about us? #{@registration.referral_source&.name}    Do you have any pets? #{@registration.pets}"
    end
  end
  
  pdf.dash 1
  pdf.stroke { pdf.line [10, pdf.cursor], [500, pdf.cursor]}
  
end
