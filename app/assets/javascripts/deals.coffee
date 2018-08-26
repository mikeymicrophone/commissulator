# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@activate_status_picker = (deal_id) ->
  $('#status_picker_for_deal_' + deal_id).on 'change', 'select', (change_event) ->
    $.ajax
      url: '/deals/' + deal_id
      type: 'PATCH'
      data: 
        deal: 
          status: change_event.currentTarget.value

$(document).on 'turbolinks:load', ->
  $('#deal_control').on 'click', '#deal_removal_link', (click_event) ->
    $('.deal_removal').slideToggle(1200)
