module DocumentsHelper
  def document_row_for document
    columns = [
      content_tag(:td, document.name),
      content_tag(:td, document.role),
      content_tag(:td, document.commission ? link_to(fa_icon(:stream, :size => '2x'), document.commission, :title => 'Review Commission Data') : ''),
      content_tag(:td, link_to(fa_icon(:file_invoice_dollar, :text => document.deal&.reference, :size => '2x'), document.deal)),
      content_tag(:td, link_to(fa_icon(:crosshairs, :size => '2x'), document.capture, :title => 'Quick View')),
      content_tag(:td, link_to(fa_icon(:cloud_download_alt, :size => '2x'), rails_blob_path(document.capture, disposition: 'attachment'), :title => 'Download')),
      content_tag(:td, link_to(fa_icon(:envelope_open, :size => '2x'), document, :title => 'Details')),
      content_tag(:td, link_to(fa_icon(:edit, :size => '2x'), edit_document_path(document), :title => 'Edit Metadata')),
      content_tag(:td, link_to(fa_icon(:joint, :size => '2x'), document, method: :delete, data: { confirm: 'Are you sure?' }, :title => 'Delete'))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def document_role_options
    options_for_select document_roles
  end
  
  def document_roles
    [
      'Listing (from LEAR)',
      'Lease (First Page and Signature Page)',
      'NY State Agency Disclosure',
      'Proof of Commission Payment',
      'Exclusive Agreement with Landlord',
      'Owner Pay Invoice',
      'Other'
    ]
  end
  
  def document_uploader_area
    tag.div :id => 'document_uploader_area'
  end
end
