# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('.commission_form_row').on 'click', '.row_remover', ->
    $($(this).closest('.commission_form_row')).remove()
