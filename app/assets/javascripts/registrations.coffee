$(document).on 'turbolinks:load', ->
  $('.datepicker').datepicker({
      changeMonth: true,
      changeYear: true,
      yearRange: "1940:2010"
    });

  $('.datepicker_moving').datepicker();
  
  $('#registration_interface').on 'submit', 'form', ->
    $(this).spin()
  
  $('#registration_interface').on 'change', '#registration_occupants', ->
    $.ajax
      url: '/registrant_add'
      data: 
        number_of_roommates: $('#registration_occupants').val()
        number_of_roommates_shown: $('.registrant').length
      dataType: 'script'
  
  $('#registration_interface').on 'change', '#registration_size', ->
    occupation = 
      'Studio': 1
      'One Bedroom': 1
      'Two Bedroom': 2
      'Three Bedroom': 3
      'Four Bedroom': 4
    
    $.ajax
      url: '/registrant_add'
      data: 
        number_of_roommates: occupation[$('#registration_size').val()]
        number_of_roommates_shown: $('.registrant').length
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
