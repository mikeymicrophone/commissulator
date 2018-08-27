$(document).on 'turbolinks:load', ->
  $('form.document').on 'change', '#document_role', ->
    if $('#document_role').val() == 'Proof of Commission Payment'
      $('#check_instructions').css 'display', 'inline-block'
    else
      $('#check_instructions').css 'display', 'none'
