module EmployersHelper

	def employer_row_for employer
		columns = [
			content_tag(:td, link_to_name_with_icon(employer)),
			content_tag(:td, employer.industries.map(&:name).to_sentence),
			content_tag(:td, link_to_associated(employer, :employments)),
			content_tag(:td, link_to_associated(employer, :emails)),
			content_tag(:td, link_to_associated(employer, :phones)),
			content_tag(:td, link_to_associated(employer, :social_accounts)),
			content_tag(:td, employer.address),
			content_tag(:td, employer.url),
			content_tag(:td, edit_link_for(employer) ),
			content_tag(:td, delete_link_for(employer))
		]
		columns.join.html_safe
	end

	
end
