module EmployersHelper
    def edit_employer_link employer
        if current_avatar.admin?
            link_to fa_icon(:highlighter), edit_employer_path(employer), :title => 'Edit'
        end
    end

    def delete_employer_link employer
        if current_avatar.admin?
            link_to fa_icon(:backspace), employer, method: :delete, data: { confirm: 'Are you sure?' }, :title => 'Delete'
        end
    end
end
