calculation_suspended = ->
  $('#suspend_calculation').prop('checked')

list = ->
  $('#commission_listed_monthly_rent').val($('#commission_leased_monthly_rent').val())

@derive = ->
  unless calculation_suspended()
    list()
    annualize()
    ripple()
    total()

annualize = ->
  unless calculation_suspended()
    $('#commission_annualized_rent').val(($('#commission_leased_monthly_rent').val() * 12).toFixed 2)

ripple = ->
  unless calculation_suspended()
    broker_fee = $('#commission_annualized_rent').val() * 0.15 # assuming 15% because that is currently the standard rate
    $('#commission_tenant_side_commission').val(broker_fee.toFixed 2)

@total = ->
  unless calculation_suspended()
    commission = tenant_side() + owner_side()
    $('#commission_total_commission').val(commission.toFixed 2)
    $('#commission_commission_fee_percentage').val((commission * 100/ annual()).toFixed 1)
    commission

annual = ->
  $('#commission_annualized_rent').val()

tenant_side = ->
  if $('#commission_tenant_side_commission').val() != ''
    parseFloat $('#commission_tenant_side_commission').val()
  else
    0

owner_side = ->
  if $('#commission_owner_pay_commission').val() != ''
    parseFloat $('#commission_owner_pay_commission').val()
  else
    0

commission = ->
  total()

co_broke_commission = ->
  if co_broke_owed()
    commission() / 2
  else
    0

co_broke_owed = ->
  $('input:checkbox.co_broke:checked').exists()

listing_fee_owed = ->
  $('input:checkbox.listing_fee:checked').exists()

referral_owed = ->
  $('input:checkbox.referral:checked').exists()

update_inbound = ->
  unless calculation_suspended()
    $('#commission_co_broke_commission').val co_broke_commission().toFixed 2
    base = commission() - co_broke_commission()
    final = base
    # if listing_fee_owed()
    #   final = final * ((100 - $('#commission_listing_fee_percentage').val()) / 100)
    if referral_owed()
      final = final - $('#commission_referral_payment').val()
    $('#commission_citi_commission').val final.toFixed 2

@referral = (field)->
  unless calculation_suspended()
    referral_fee = parseFloat($(field).val())
    $('#commission_referral_payment').val referral_fee.toFixed 2

$(document).on 'turbolinks:load', ->
  $('#commission_editor').on 'blur', 'input.commission', ->
    update_inbound()
  
  $('#checkboxes').on 'change', 'input:checkbox', ->
    update_inbound()
  
  $('#checkboxes').on 'blur', 'input.referral', ->
    referral(this)
    update_inbound()
  
  $('#checkboxes').on 'change', 'input:checkbox', (change_event) ->
    selected_box = $(change_event.currentTarget)
    row = $(selected_box).closest 'tr'
    table = $(selected_box).closest 'table'
    boxes = table.find 'input'
    needed_boxes = row.find 'input'
    unneeded_boxes = boxes.not(needed_boxes).get()
    # $(unneeded_boxes).each((index, box) => $(box).prop('disabled', selected_box.prop('checked')))
    # $(needed_boxes).each((index, box) => $(box).css('border-color', 'green'))

  $('#commission_control').on 'click', '#commission_removal_link', (click_event) ->
    $('.commission_removal').slideToggle(1200)
  
  $('#commission_participation_registration').on 'change', '#assist_assistant_id', ->
    if $('#assist_assistant_id').val() == 'Add Name'
      $('#assistant_adder').css 'display', 'block'
