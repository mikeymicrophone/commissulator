$(document).on 'turbolinks:load', ->
  $('.datepicker').datepicker({
      changeMonth: true,
      changeYear: true,
      yearRange: "1940:2010"
    });
