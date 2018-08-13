# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#commission_participation_registration').on 'click', '#participant_adder_submission', (click_event) ->
    $(click_event.currentTarget).closest('form').submit()

