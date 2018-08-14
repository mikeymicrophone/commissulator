# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@annualize = ->
  if $('#commission_annualized_rent').val() == ''
    $('#commission_annualized_rent').val(($('#commission_leased_monthly_rent').val() * 12).toFixed 2)

@ripple = ->
  if $('#commission_tenant_side_commission').val() == ''
    broker_fee = $('#commission_annualized_rent').val() * ($('#commission_commission_fee_percentage').val() / 100)
    $('#commission_tenant_side_commission').val(broker_fee.toFixed 2)
    total()

@total = ->
  # if $('#commission_total_commission').val() == ''
  sum = parseFloat($('#commission_tenant_side_commission').val()) + parseFloat($('#commission_owner_pay_commission').val())
  $('#commission_total_commission').val(sum.toFixed 2)

$(document).on 'turbolinks:load', ->
  $('#checkboxes').on 'change', 'input:checkbox', (change_event) ->
    selected_box = $(change_event.currentTarget)
    console.log(selected_box.prop('checked'))
    row = $(selected_box).closest('tr')
    table = $(selected_box).closest('table')
    boxes = table.find('input')
    needed_boxes = row.find('input')
    unneeded_boxes = boxes.not(needed_boxes).get()
    $(unneeded_boxes).each((index, box) => $(box).prop('disabled', selected_box.prop('checked')))
    $(needed_boxes).each((index, box) => $(box).css('border-color', 'green'))
