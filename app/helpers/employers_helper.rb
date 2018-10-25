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
			content_tag(:td, employer.url)
		]
		columns.join.html_safe
	end

	def edit_employer_link employer
		if can? :edit, employer
			link_to fa_icon(:highlighter), edit_employer_path(employer), :title => 'Edit'
		end
	end

	def delete_employer_link employer
		if can? :delete, employer
			link_to fa_icon(:backspace), employer, method: :delete, data: { confirm: 'Are you sure?' }, :title => 'Delete'
		end
	end
end
