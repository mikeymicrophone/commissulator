landlords = {
  url: "/landlords.json"
  getValue: 'name'
  list:
    onSelectItemEvent: () ->
      landlord = $('#commission_landlord_name').getSelectedItemData()
      $('#commission_landlord_email').val(landlord.email)
      $('#commission_landlord_phone_number').val(landlord.phone_number)
}

$(document).on 'turbolinks:load', ->
  $('#commission_landlord_name').easyAutocomplete landlords
