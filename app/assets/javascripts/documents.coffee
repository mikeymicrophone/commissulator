@instruct_check_format = ->
  $('form.document').on 'change', '#document_role', ->
    if $('#document_role').val() == 'Proof of Commission Payment' || $('#document_role').val() == 'Owner Pay Invoice'
      $('#check_instructions').css 'display', 'inline-block'
    else
      $('#check_instructions').css 'display', 'none'
