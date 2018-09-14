calculation_suspended = ->
  $('#suspend_calculation').prop('checked')

list = ->
  unless calculation_suspended()
    if $('#commission_listed_monthly_rent').val() == ''
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
    $('#commission_commission_fee_percentage').val(15)

total = ->
  unless calculation_suspended()
    accrued_commission = tenant_side() + listing_side() + owner_side()
    $('#commission_total_commission').val accrued_commission.toFixed 2
    accrued_commission

percent = ->
  unless calculation_suspended()
    $('#commission_commission_fee_percentage').val((commission() * 100/ annual()).toFixed 1)

annual = ->
  unless calculation_suspended()
    $('#commission_annualized_rent').val()

tenant_side = ->
  unless calculation_suspended()
    if $('#commission_tenant_side_commission').val() != ''
      parseFloat $('#commission_tenant_side_commission').val()
    else
      0

listing_side = ->
  unless calculation_suspended()
    if $('#commission_listing_side_commission').val() != ''
      parseFloat $('#commission_listing_side_commission').val()
    else
      0

owner_side = ->
  unless calculation_suspended()
    if $('#commission_owner_pay_commission').val() != ''
      parseFloat $('#commission_owner_pay_commission').val()
    else
      0

listing_fee = ->
  unless calculation_suspended()
    if listing_fee_owed()
      listing_fee_percentage = parseFloat $('#commission_listing_fee_percentage').val()
      listing_fee_per = listing_fee_percentage / 100
      total() * listing_fee_per
    else
      0

referral = ->
  unless calculation_suspended()
    if referral_owed()
      parseFloat $('#commission_referral_payment').val()
    else
      0

origination_fee = ->
  unless calculation_suspended()
    listing_fee() + referral()

commission = ->
  unless calculation_suspended()
    total()

co_broke_commission = ->
  unless calculation_suspended()
    if co_broke_owed()
      commission() / 2
    else
      0

listing_side_commission = ->
  unless calculation_suspended()
    if listing_side_owed()
      tenant_side() / 2
    else
      0

co_broke_owed = ->
  unless calculation_suspended()
    $('input:checkbox.co_broke:checked').exists()

listing_side_owed = ->
  unless calculation_suspended()
    $('input:checkbox#commission_citi_habitats_agent:checked').exists()

listing_fee_owed = ->
  unless calculation_suspended()
    $('input:checkbox.listing_fee:checked').exists()

referral_owed = ->
  unless calculation_suspended()
    $('input:checkbox.referral:checked').exists()

update_tenant_side = ->
  unless calculation_suspended()
    tenant_side_commission = annual() * $('#commission_commission_fee_percentage').val() / 100
    $('#commission_tenant_side_commission').val tenant_side_commission.toFixed 2
    accrued_commission = tenant_side_commission + owner_side()
    $('#commission_total_commission').val accrued_commission.toFixed 2

update_inbound = ->
  unless calculation_suspended()
    if listing_side_owed()
      unless listing_side() > 0
        $('#commission_listing_side_commission').val listing_side_commission().toFixed 2
        $('#commission_tenant_side_commission').val listing_side_commission().toFixed 2
    $('#commission_co_broke_commission').val co_broke_commission().toFixed 2
    base = commission() - co_broke_commission()
    final = base - origination_fee()
    $('#commission_citi_commission').val final.toFixed 2

@referral = (field)->
  unless calculation_suspended()
    referral_fee = parseFloat($(field).val())
    $('#commission_referral_payment').val referral_fee.toFixed 2

$(document).on 'turbolinks:load', ->
  $('#commission_editor').on 'blur', 'input.commission', ->
    update_inbound()
    percent()
  
  $('#commission_editor').on 'blur', '#commission_commission_fee_percentage', ->
    update_tenant_side()
  
  $('#checkboxes').on 'change', 'input:checkbox', ->
    update_inbound()
  
  $('#checkboxes').on 'blur', 'input.referral_amount', ->
    referral(this)
    update_inbound()
  
  $('#commission_participation_registration').on 'change', '#assist_agent_id', ->
    if $('#assist_agent_id').val() == 'Add Name'
      $('#agent_adder').slideDown(700)
    else
      $('#agent_adder').slideUp(1300)
