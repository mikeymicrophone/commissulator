prawn_document do
  stroke_axis
  font_families.update 'Oswald' => {:normal => "#{Rails.root}/app/assets/fonts/Oswald-Medium.ttf"}
  font 'Times-Roman', :size => 10
  gap = 5
  
  image "#{Rails.root}/app/assets/images/citi_habitats_logo_tagline.jpg", :width => 240
  font 'Oswald' do
    draw_text "CLIENT REGISTRATION / FEE AGREEMENT", :size => 15, :at => [250, 755]
  end
  
  bounding_box [250, 750], :width => 250, :height => 50 do
    draw_text "Date:", :at => [5, 40]
    line [30, 38], [135, 38]
    draw_text @registration.created_at.strftime("%-m/%-d/%Y"), :at => [60, 40]
    draw_text "Agent:", :at => [140, 40]
    line [170, 38], [240, 38]
    draw_text @registration.agent&.name, :at => [180, 40]
    draw_text "Budget:", :at => [5, 25]
    line [40, 23], [135, 23]
    draw_text number_to_round_currency(@registration.maximum_price), :at => [75, 25]
    draw_text "Apartment Size:", :at => [5, 10]
    line [72, 8], [135, 8]
    draw_text @registration.size, :at => [72, 10]
    stroke
  end
  
  bounding_box [0, 685], :width => 525, :height => 25 do
    text @registration_introduction
  end
  
  dash 1
  stroke { line [0, 660], [520, 660] }
  undash
  
  @view_context_holder.client_box(self, [0, 655], 1)
  @view_context_holder.client_box(self, [272, 655], 2)
  
  # @registration.clients.each_with_index do |client, index|
  #   height = 653 - (((index) / 2)) * 260
  #   positioning = index.odd? ? [255, height] : [0, height]
  #   bounding_box positioning, :width => 250 do
  #     bounding_box [gap, cursor - gap], :width => 240 do
  #       font 'Oswald', :size => 16 do
  #         text "CLIENT #{index + 1}"
  #       end
  #       text "<u>#{padded_display client.name}</u>", :inline_format => true
  #       text "<u>#{padded_display client.leases.first&.address}</u>", :inline_format => true if client.leases.present?
  #       client.phones.each do |phone|
  #         text "<u>#{padded_display phone.number} (#{phone.variety})</u>", :inline_format => true
  #       end
  #       client.emails.last do |email|
  #         text "<u>#{email.address}</u>", :inline_format => true
  #       end
  #       client.employers.last do |employer|
  #         text "Employer: <u>#{padded_display employer.name}</u>", :inline_format => true
  #         text "Address: <u>#{padded_display employer.address}</u>", :inline_format => true
  #         text "Position: <u>#{padded_display employer.employment_of(client)&.position}</u>", :inline_format => true
  #         text "Annual Income: <u>#{padded_display number_to_round_currency employer.employment_of(client)&.income}</u>", :inline_format => true
  #       end
  #       client.leases.last do |lease|
  #         text "Current Landlord: <u>#{padded_display lease.landlord&.name}</u>", :inline_format => true
  #       end
  #     end
  #   end
  # end
  
  dash 1
  stroke { line [259, 653], [259, 454] }
  stroke { line [0, 450], [520, 450]}
  undash
  
  bounding_box [0, 444], :width => 510, :height => 50 do
    draw_text 'Move-in date:', :at => [0, 40]
    line [60, 38], [155, 38]
    
    draw_text 'Lease expiration date:', :at => [160, 40]
    line [250, 38], [355, 38]
    
    # draw_text @registration.move_by&.strftime("%B %-d")
    draw_text 'Number of people:', :at => [360, 40]
    line [440, 38], [520, 38]
    
    # draw_text @registration.occupants
    draw_text 'Apartments seen:', :at => [0, 25]
    line [73, 23], [520, 23]
    
    apartments_seen = @registration.apartments.map do |apartment|
      "#{apartment.name} #{apartment.comment}"
    end.join ' '
    # draw_text apartments_seen
    draw_text 'How did you hear about us?', :at => [0, 10]
    line [115, 8], [245, 8]
    
    # draw_text @registration.referral_source&.name
    draw_text 'Do you have any pets?', :at => [250, 10]
    line [345, 8], [520, 8]
    
    # draw_text @registration.pets
    stroke
    stroke_axis
  end
  
  dash 1
  stroke { line [0, 395], [520, 395]}
  
  bounding_box [0, 385], :width => 520, :height => 140 do
    font 'Times-Roman', :size => 8
  
    text @registration_implication
    move_down 8
    text @registration_rental_fee
    move_down 8
    text @registration_condo_fee
    move_down 8
    text @registration_short_term
    move_down 8
    text @registration_short_term_fees, :indent_paragraphs => 10
    stroke_bounds
  end
  
  undash
  stroke { line [0, 35], [520, 35] }
  font 'Oswald' do
    draw_text 'CITIHABITATS.COM', :at => [460, 25]
  end
end
