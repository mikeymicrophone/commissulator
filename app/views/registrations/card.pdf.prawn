prawn_document do |pdf|
  # pdf.stroke_axis
  pdf.font_families.update 'Oswald' => {:normal => "#{Rails.root}/app/assets/fonts/Oswald-Medium.ttf"}
  pdf.font "Times-Roman", :size => 10
  pdf.default_leading 7
  gap = 5
  
  pdf.image "#{Rails.root}/app/assets/images/citi_habitats_logo_tagline.jpg", :width => 240
  pdf.font 'Oswald' do
    pdf.draw_text "CLIENT REGISTRATION / FEE AGREEMENT", :size => 15, :at => [250, 755]
  end
  
  pdf.bounding_box [250, 750], :width => 250 do
    pdf.text "Date: <u>#{pad @registration.created_at.strftime("%-m/%-d/%Y"), 10}</u>    Agent: <u>#{pad @registration.agent&.name, 10}</u>", :inline_format => true
    pdf.text "Budget: <u>#{pad number_to_round_currency(@registration.minimum_price), 6}-#{pad number_to_round_currency(@registration.maximum_price), 6}</u>", :inline_format => true
    pdf.text "Apartment Size: <u>#{pad @registration.size, 10}</u>", :inline_format => true
  end
  
  pdf.move_down 12
  pdf.text t('hello')[:registration_card], :leading => 1
  pdf.move_down 3
  
  pdf.dash 1
  pdf.stroke { pdf.line [0, pdf.cursor], [520, pdf.cursor]}
  pdf.undash
  
  @registration.clients.each_with_index do |client, index|
    height = 653 - (((index) / 2)) * 260
    positioning = index.odd? ? [255, height] : [0, height]
    pdf.bounding_box positioning, :width => 250 do
      pdf.bounding_box [gap, pdf.cursor - gap], :width => 240 do
        pdf.font 'Oswald', :size => 16 do
          pdf.text "CLIENT #{index + 1}"
        end
        pdf.text "<u>#{client.name}</u>", :inline_format => true
        pdf.text "<u>#{client.leases.first&.address}</u>", :inline_format => true
        client.phones.each do |phone|
          pdf.text "<u>#{phone.number} (#{phone.variety})</u>", :inline_format => true
        end
        client.emails.each do |email|
          pdf.text "<u>#{email.address}</u>", :inline_format => true
        end
        client.employers.each do |employer|
          pdf.text "Employer: <u>#{employer.name}</u>", :inline_format => true
          pdf.text "Address: <u>#{employer.address}</u>", :inline_format => true
          pdf.text "Position: <u>#{employer.employment_of(client)&.position}</u>", :inline_format => true
          pdf.text "Annual Income: <u>#{number_to_round_currency employer.employment_of(client)&.income}</u>", :inline_format => true
        end
        client.leases.each do |lease|
          pdf.text "Current Landlord: <u>#{lease.landlord&.name}</u>", :inline_format => true
        end
      end
    end
  end
  
  pdf.dash 1
  pdf.stroke { pdf.line [253, 653], [253, pdf.cursor + 4] }
  pdf.stroke { pdf.line [0, pdf.cursor], [520, pdf.cursor]}
  pdf.undash
  
  pdf.bounding_box [0, pdf.cursor], :width => 510 do
    pdf.bounding_box [gap, pdf.cursor - gap], :width => 500 do
      pdf.text "Move date: <u>#{@registration.move_by&.strftime("%-m/%-d")}</u>    At the latest: <u>#{@registration.move_by_latest&.strftime("%-m/%-d")}</u>    Number of people: <u>#{@registration.occupants}</u>", :inline_format => true
      @registration.apartments.each do |apartment|
        pdf.text "<u>#{apartment.name}</u>", :inline_format => true
      end
      pdf.text "How did you hear about us? <u>#{@registration.referral_source&.name}</u>    Do you have any pets? <u>#{@registration.pets}</u>", :inline_format => true
    end
  end
  
  pdf.dash 1
  pdf.stroke { pdf.line [0, pdf.cursor], [520, pdf.cursor]}
  
  pdf.move_down 10
  pdf.font "Times-Roman", :size => 8
  pdf.default_leading 1
  
  pdf.text t('legal')[:registration_card][:implication]
  pdf.move_down 8
  pdf.text t('legal')[:registration_card][:rental_fee]
  pdf.move_down 8
  pdf.text t('legal')[:registration_card][:condo_fee]
  pdf.move_down 8
  pdf.text t('legal')[:registration_card][:short_term]
  pdf.move_down 8
  pdf.text t('legal')[:registration_card][:short_term_fees], :indent_paragraphs => 10
  
  pdf.undash
  pdf.stroke { pdf.line [0, 10], [520, 10] }
  pdf.font 'Oswald' do
    pdf.draw_text 'CITIHABITATS.COM', :at => [460, 0]
  end
end
