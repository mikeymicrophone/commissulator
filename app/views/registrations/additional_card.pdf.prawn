font_families.update 'Oswald' => {:normal => "#{Rails.root}/app/assets/fonts/Oswald-Medium.ttf"}
font 'Times-Roman', :size => 10

image "#{Rails.root}/app/assets/images/citi_habitats_logo_tagline.jpg", :width => 240
@view_context_holder.client_box(self, [0, 655], 3, @additional_clients.first)
@view_context_holder.client_box(self, [272, 655], 4, @additional_clients.second)
