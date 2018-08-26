module DocumentsHelper
  def document_row_for document
    columns = [
      content_tag(:td, document.name),
      content_tag(:td, document.role),
      content_tag(:td, link_to_name(document.deal, :reference)),
      content_tag(:td, link_to('View', document.capture)),
      content_tag(:td, link_to('Download', rails_blob_path(document.capture, disposition: "attachment"))),
      content_tag(:td, link_to('Details', document)),
      content_tag(:td, link_to('Edit', edit_document_path(document))),
      content_tag(:td, link_to('Delete', document, method: :delete, data: { confirm: 'Are you sure?' }))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
end
