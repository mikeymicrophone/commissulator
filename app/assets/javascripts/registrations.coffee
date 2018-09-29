$(document).on 'turbolinks:load', ->
  $('.datepicker').datepicker({
      changeMonth: true,
      changeYear: true,
      yearRange: "1940:2010"
    });

  $('.datepicker_moving').datepicker();
  
  $('#registration_interface').on 'change', '#registration_occupants', ->
    $.ajax
      url: '/registrant_add'
      data: 
        number_of_roommates: $('#registration_occupants').val()
      dataType: 'script'

  $('#registration_interface').on 'change', '#registration_maximum_price', ->
    $.ajax
      url: '/clients/new'
      dataType: 'script'

  $('#registration_interface').on 'change', '#client_first_name', ->
    $.ajax
      url: '/leases/new'
      dataType: 'script'

  $('#registration_interface').on 'change', '#client_date_of_birth', ->
    $.ajax
      url: '/emails/new'
      dataType: 'script'
